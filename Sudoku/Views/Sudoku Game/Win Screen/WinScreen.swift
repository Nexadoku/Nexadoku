
import SwiftUI

struct WinScreen: View {
    var onExit: () -> Void
    var timeElapsed: Int
    var mistakes: Int
    var level: DifficultyLevel
    
    @EnvironmentObject private var navigator: Navigator
    @Environment(\.dismiss) var dismiss

    @AppStorage("mistakesEnabled") var mistakesEnabled: Bool = true
    @AppStorage("timerEnabled") var timerEnabled: Bool = true

    @State private var animate = false
    @State private var confettiPieces: [Confetti] = []

    private let colors: [Color] = [
        .red, .yellow, .blue, .green, .purple, .pink, .orange,
        Color.indigo, Color.cyan, Color.white.opacity(0.8)
    ]

    private let shapes: [ConfettiShape] = [.circle, .star, .diamond, .rectangle]

    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        ZStack {
            SystemDarkBackground()
            
            ForEach(confettiPieces) { piece in
                ConfettiShapeView(piece: piece)
                    .frame(width: piece.size, height: piece.size)
                    .position(x: piece.x, y: piece.y)
                    .opacity(piece.opacity)
                    .blendMode(.plusLighter)
                    .animation(.easeOut(duration: piece.duration), value: piece.y)
            }

            VStack(spacing: 20) {
                    VStack(spacing: 20) {
                        Text("Congratulations!")
                            .font(.system(size: 34, weight: .heavy))
                            .foregroundStyle(
                                Color.white
                            )
                            .shadow(radius: 12)
                            .opacity(animate ? 1 : 0)
                            .scaleEffect(animate ? 1 : 0.95)
                            .animation(.easeOut(duration: 0.8).delay(0.3), value: animate)
                        
                        statsCapsule
                            .opacity(animate ? 1 : 0)
                            .offset(y: animate ? 0 : 20)
                            .animation(.easeOut(duration: 1.0).delay(0.5), value: animate)
                            .padding()

                        
                        Button(action: {
                            navigator.pop()
                        }) {
                            Text("Return to Main Menu")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 30)
                                .background(
                                    .purple
                                )
                                .cornerRadius(26)
                                .shadow(radius: 8)
                        }
                        .padding(.bottom, 20)
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : 20)
                        .animation(.easeOut(duration: 1.0).delay(0.7), value: animate)
                        
                    
                }
            }
        }
        .onAppear {
            animate = true
            generateConfetti()
        }
    }

func generateConfetti() {
    for i in 0..<100 {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.06) {
            let shape = shapes.randomElement()!
            var newPiece = Confetti(
                shape: shape,
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: -20,
                size: CGFloat.random(in: 10...15),
                color: colors.randomElement() ?? .white,
                opacity: Double.random(in: 0.7...1),
                duration: Double.random(in: 2.5...4),
                
            )
            confettiPieces.append(newPiece)
            
            // Animate falling
            withAnimation {
                if let lastIndex = confettiPieces.indices.last {
                    confettiPieces[lastIndex].y = UIScreen.main.bounds.height + 50
                    
                }
            }
        }
    }
}

    var statsCapsule: some View {
        VStack(spacing: 20) {
            Text("Game Summary")
                .foregroundColor(.white)
                .font(.title3.bold())

            if mistakesEnabled {
                statRow(title: "Mistakes:", value: "\(mistakes)")
            }
            
            if timerEnabled {
                statRow(title: "Time:", value: "\(timeFormatted(timeElapsed))")
            }
            
            statRow(title: "Level:", value: "\(level.rawValue.capitalized)")
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.purple.opacity(0.4), .black.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.1), lineWidth: 1))
        .shadow(radius: 10)
    }

    func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
            Spacer()
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .white.opacity(0.8), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Confetti Model

enum ConfettiShape {
    case circle, star, diamond, rectangle
}

struct Confetti: Identifiable {
    let id = UUID()
    let shape: ConfettiShape
    let x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let color: Color
    let opacity: Double
    let duration: Double
}

// MARK: - Confetti Shape View

struct ConfettiShapeView: View {
    let piece: Confetti

    var body: some View {
        switch piece.shape {
        case .circle:
            Circle().fill(piece.color)
        case .star:
            StarShape().fill(piece.color)
        case .diamond:
            DiamondShape().fill(piece.color)
        case .rectangle:
            RoundedRectangle(cornerRadius: piece.size / 4)
                .fill(piece.color)
        }
    }
}

// MARK: - Custom Shapes

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let points = 5
        let angle = 2 * Double.pi / Double(points * 2)

        for i in 0..<(points * 2) {
            let pointAngle = Double(i) * angle - .pi / 2
            let pointRadius = i % 2 == 0 ? radius : radius / 2.5
            let x = center.x + CGFloat(cos(pointAngle)) * pointRadius
            let y = center.y + CGFloat(sin(pointAngle)) * pointRadius
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let mid = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: CGPoint(x: mid.x, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: mid.y))
        path.addLine(to: CGPoint(x: mid.x, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: mid.y))
        path.closeSubpath()
        return path
    }
}

struct WinScreen_Previews: PreviewProvider {
    static var previews: some View {
        WinScreen(onExit: {}, timeElapsed: 87, mistakes: 2, level: .medium)
            .environmentObject(Navigator())
    }
}

