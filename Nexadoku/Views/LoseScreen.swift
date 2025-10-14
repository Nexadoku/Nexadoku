
import SwiftUI

struct LoseScreen: View {
    var onExit: () -> Void
    var onRetry: () -> Void

    @EnvironmentObject private var navigator: Navigator

    @State private var appear = false

    // More horizontal lanes so there are more floating numbers visible
    private let floatingColumns: [CGFloat] = [-220, -190, -160, -130, -100, -70, -40, -10, 20, 50, 80, 110, 140, 170, 200, 230]

    var body: some View {
        ZStack {
            DarkBackground()
            // Floating numbers 1..9 in purple, moving gently
            GeometryReader { proxy in
                let height = proxy.size.height
                ZStack {
                    // Continuous stream: two numbers per lane with a phase offset
                    ForEach(0..<floatingColumns.count, id: \.self) { lane in
                        let xPos = floatingColumns[lane]
                        let baseDuration = Double.random(in: 6.0...8.0)
                        let offsetY = height / 2 + 140

                        ForEach(0..<2, id: \.self) { phase in
                            FloatingNumber(
                                text: "\((lane + phase) % 9)",
                                x: xPos,
                                startY: phase == 0 ? (height + 80) : (height + 80 + offsetY),
                                endY: -260,
                                delay: Double(phase) * (baseDuration / 2),
                                scale: CGFloat(Double.random(in: 1.0...1.8)),
                                duration: baseDuration
                            )
                        }
                    }
                }
                .ignoresSafeArea()
            }

            VStack(spacing: 28) {
                // Glassy header card with YOU LOSE
                VStack(spacing: 10) {
                    Text("YOU")
                        .font(.system(size: 46, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(GlassyPurple(cornerRadius: 18))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .scaleEffect(appear ? 1.0 : 0.85)
                        .opacity(appear ? 1.0 : 0.0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.05), value: appear)

                    Text("LOSE")
                        .font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 12)
                        .background(GlassyPurple(cornerRadius: 22))
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .scaleEffect(appear ? 1.0 : 0.85)
                        .opacity(appear ? 1.0 : 0.0)
                        .animation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.15), value: appear)

                    Text("You made 3 mistakes. Try again!")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                        .opacity(appear ? 1 : 0)
                        .animation(.easeInOut(duration: 0.25).delay(0.25), value: appear)
                        .padding()
                }

                // Actions with a glass container
                VStack(spacing: 14) {
                    GlassButton(title: "Retry", systemIcon: "arrow.clockwise", color: .purple.opacity(0.7)) {
                        onRetry()
                    }
                    GlassButton(title: "Exit", systemIcon: "house.fill", color: .red.opacity(0.7)) {
                        navigator.pop()
                        onExit()
                    }
                }
                .padding(.horizontal, 24)
                .opacity(appear ? 1 : 0)
                .animation(.easeInOut(duration: 0.3).delay(0.35), value: appear)
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            appear = true
        }
    }
}

// MARK: - Subviews

private struct GlassyPurple: View {
    var cornerRadius: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.purple.opacity(0.9),
                            Color.purple.opacity(0.6),
                            Color.purple.opacity(0.35)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Soft highlight
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.35),
                            Color.white.opacity(0.12),
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
                .blendMode(.screen)

            // Border
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.85),
                            Color.white.opacity(0.25)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
    }
}

private struct GlassButton: View {
    var title: String
    var systemIcon: String
    var color: Color
    var action: () -> Void

    @State private var pressed = false

    var body: some View {
        Button(action: {
            VibrationManager.shared.lightImpact()
            action()
        }) {
            HStack(spacing: 10) {
                Image(systemName: systemIcon)
                    .font(.system(size: 18, weight: .bold))
                Text(title)
                    .font(.system(size: 18, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
            )
            .scaleEffect(pressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: pressed)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { isPressing in
            pressed = isPressing
        }, perform: {})
    }
}

private struct FloatingNumber: View {
    var text: String
    var x: CGFloat
    var startY: CGFloat
    var endY: CGFloat
    var delay: Double
    var scale: CGFloat
    var duration: Double

    @State private var atEnd = false

    var body: some View {
        Text(text)
            .font(.system(size: 28, weight: .black, design: .rounded))
            .foregroundColor(.purple)
            .opacity(0.95)
            .scaleEffect(scale)
            .offset(x: x, y: atEnd ? endY : startY)
            .rotationEffect(.degrees(atEnd ? 12 : -12))
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: false)
                .delay(delay),
                value: atEnd
            )
            .onAppear { atEnd = true }
    }
}
