
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
    @State private var digitparticles: [DigitParticle] = []

    private let colors: [Color] = [
        .white
    ]

    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        ZStack {
            SystemBackground()
            
            ForEach(digitparticles) { particle in
                Text(particle.digit)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(particle.color)
                    .position(particle.position)
                    .offset(particle.offset)
                    .opacity(particle.opacity)
                    .scaleEffect(particle.scale)
            }

            VStack(spacing: 20) {
                Text("Congratulations!")
                    .font(.system(size: 34, weight: .black))
                    .foregroundStyle(Color.white)
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
                        .background(.purple)
                        .cornerRadius(26)
                        .shadow(radius: 8)
                }
                .padding(.bottom, 20)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.1), value: animate)
            }
        }
        .onAppear {
            animate = true
            launchDigitExplosions()
        }
    }

    func launchDigitExplosions() {
        let explosionCenters: [CGPoint] = (0..<5).map { _ in
            CGPoint(
                x: CGFloat.random(in: 60...(UIScreen.main.bounds.width - 60)),
                y: CGFloat.random(in: 50...(UIScreen.main.bounds.height / 2.5))
            )
        }
        launchNextExplesion(from: explosionCenters, index: 0)
    }

    func launchNextExplesion(from centers: [CGPoint], index: Int) {
        guard index < centers.count else { return }

        let center = centers[index]

        launchDigitExplosion(center: center) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                launchNextExplesion(from: centers, index: index + 1)
            }
        }
    }

    func launchDigitExplosion(center: CGPoint, completion: @escaping () -> Void) {
        let digits = (0...9).map { "\($0)" }

        for _ in 0..<35 {
            let angle = Double.random(in: 0...(2 * .pi))
            let radius = CGFloat.random(in: 100...200)
            let dx = cos(angle) * radius
            let dy = sin(angle) * radius

            let particle = DigitParticle(
                digit: digits.randomElement() ?? "5",
                position: center,
                offset: .zero,
                opacity: 1,
                scale: 1,
                color: .white
            )

            digitparticles.append(particle)

            withAnimation(.easeOut(duration: 1)) {
                if let index = digitparticles.indices.last {
                    digitparticles[index].offset = CGSize(width: dx, height: dy)
                    digitparticles[index].opacity = 0
                    digitparticles[index].scale = 1
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            digitparticles.removeAll()
            completion()
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
                colors: [.purple],
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
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .white.opacity(0.5), radius: 4, x: 0, y: 2)
        }
    }
}

struct DigitParticle: Identifiable {
    let id = UUID()
    let digit: String
    var position: CGPoint
    var offset: CGSize
    var opacity: Double = 1.0
    var scale: CGFloat = 1.0
    var color: Color
}

struct WinScreen_Previews: PreviewProvider {
    static var previews: some View {
        WinScreen(onExit: {}, timeElapsed: 87, mistakes: 2, level: .medium)
            .environmentObject(Navigator())
    }
}
