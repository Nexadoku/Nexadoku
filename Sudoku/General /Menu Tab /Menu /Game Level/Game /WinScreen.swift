import SwiftUI

struct WinScreen: View {
    var onExit: () -> Void
    var timeElapsed: Int
    var mistakes: Int
   
    @EnvironmentObject private var navigator: Navigator

    @State private var animateSparkle = false
    @State private var fireworks: [Firework] = []
    @State private var readyForNextFirework = true
    private let explosionCenter = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4)

    @AppStorage("mistakesEnabled") var mistakesEnabled: Bool = true
    @AppStorage("timerEnabled") var timerEnabled: Bool = true
    
    private let fireworkColors: [Color] = [.white, .yellow, .purple, .pink]

    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        ZStack {
            SystemDarkBackground().blur(radius: 4)
                .ignoresSafeArea()
            
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    for firework in fireworks {
                        var contextCopy = context
                        let velocity = firework.velocity
                        let angle = atan2(velocity.y, velocity.x) // угол
                        
                        let stretchFactor: CGFloat = 1.5 + CGFloat(hypot(velocity.x, velocity.y)) / 2
                        
                        contextCopy.opacity = firework.opacity
                        
                        contextCopy.transform = .init(translationX: firework.position.x, y: firework.position.y)
                        contextCopy.transform = contextCopy.transform.rotated(by: angle)
                        
                        let rect: CGRect
                        if hypot(velocity.x, velocity.y) < 2 {
                            // маленькая скорость — круг
                            rect = CGRect(x: -firework.size/2, y: -firework.size/2, width: firework.size, height: firework.size)
                        } else {
                            // большая скорость — вытянутый овал
                            rect = CGRect(x: -firework.size/2, y: -firework.size/2, width: firework.size * stretchFactor, height: firework.size)
                        }
                        
                        let path = Path(ellipseIn: rect)
                        contextCopy.fill(path, with: .linearGradient(
                            Gradient(colors: [firework.color]),
                            startPoint: .zero,
                            endPoint: CGPoint(x: 2, y: 1)
                        ))
                    }
                }
            }
            .ignoresSafeArea()
            .blendMode(.plusLighter)

            VStack(spacing: 20) {
                Spacer()
                    Text("Congratulations!")
                        .font(.system(size: 32, weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                Text("You Win!")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.white)
                
                    // Капсула, только если хотя бы один активен
                    if mistakesEnabled || timerEnabled {
                        HStack(spacing: 0) {
                            if timerEnabled {
                                VStack {
                                    Text(timeFormatted(timeElapsed))
                                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                                        .foregroundColor(.green)
                                        .shadow(color: .black, radius: 1)
                                    Text("Time")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            
                            if timerEnabled && mistakesEnabled {
                                Divider()
                                    .frame(height: 70)
                                    .background(Color.white)
                            }
                            
                            if mistakesEnabled {
                                VStack {
                                    Text("Mistakes: \(mistakes)/3")
                                        .font(.system(size: 22, weight: .semibold))
                                        .foregroundColor(.red)
                                        .shadow(color: .black, radius: 1)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding()
                        .background(
                            LinearGradient(colors: [.purple.opacity(0.3), .black.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .padding(.horizontal)
                        .shadow(radius: 10)
                    }
                
                Spacer()
                
                Button(action: {
                    navigator.pop()
                }) {
                    Text("Return to Main Menu")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 30)
                        .background(.purple)
                        .cornerRadius(26)
                        .shadow(color: .purple, radius: 10)
                        .padding(.bottom, 100)
                }
                .padding(.top, 20)
            }
        }
        .onAppear {
            animateSparkle = true
            createFirework()
        }
        .onDisappear {
            fireworks.removeAll()
        }
    }
    
    private func createFirework() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            updateFireworks()
            
            if readyForNextFirework && fireworks.count < 10 {
                readyForNextFirework = false
                startFireworks()
            }
        }
    }
    
    private func startFireworks() {
        let explosionColor = fireworkColors.randomElement() ?? .white
        
            for _ in 0..<80 {
                let angle = Double.random(in: 0...(2 * 3.14))
                let speed = Double.random(in: 4...8)
                let sparkVelocity = CGPoint(
                    x: cos(angle) * speed,
                    y: sin(angle) * speed
                )
                let spark = Firework(
                    position: explosionCenter,
                    velocity: sparkVelocity,
                    color: explosionColor,
                    lifetime: Double.random(in: 1.2...1.8),
                    size: CGFloat.random(in: 1...3),
                    opacity: 1,
                    exploded: true
                )
                fireworks.append(spark)
            }
        readyForNextFirework = true
    }
    
    private func updateFireworks() {
        var newFireworks: [Firework] = []
        
        for index in fireworks.indices {
            fireworks[index].position.x += fireworks[index].velocity.x
            fireworks[index].position.y += fireworks[index].velocity.y
            fireworks[index].lifetime -= 0.05
            fireworks[index].opacity = max(0, fireworks[index].lifetime / 2.0)
            
            if fireworks[index].lifetime <= 0 && !fireworks[index].exploded {
                fireworks[index].exploded = true
                let explosionCenter = fireworks[index].position
                let explosionColor = fireworks[index].color
                
                for _ in 0..<50 {
                    let angle = Double.random(in: 0...(2 * 3.14))
                    let speed = Double.random(in: 1.5...5)
                    let sparkVelocity = CGPoint(
                        x: cos(angle) * speed,
                        y: sin(angle) * speed
                    )
                    let spark = Firework(
                        position: explosionCenter,
                        velocity: sparkVelocity,
                        color: explosionColor,
                        lifetime: Double.random(in: 0.8...1.5),
                        size: CGFloat.random(in: 3...6),
                        opacity: 1,
                        exploded: true
                    )
                    newFireworks.append(spark)
                }
            }
        }
        fireworks.removeAll { $0.lifetime <= 0 }
        fireworks.append(contentsOf: newFireworks)
    }
}

struct Firework {
    var position: CGPoint
    var velocity: CGPoint
    var color: Color
    var lifetime: Double
    var size: CGFloat
    var opacity: Double = 1
    var exploded: Bool = false
}

struct WinScreen_Previews: PreviewProvider {
    static var previews: some View {
        WinScreen(onExit: {}, timeElapsed: 123, mistakes: 1)
            .environmentObject(Navigator())
            .preferredColorScheme(.dark)
    }
}


