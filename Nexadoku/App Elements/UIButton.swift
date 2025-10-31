
import SwiftUI

struct MagicStartButton: View {
    var title: String
    var icon: String? = nil
    var action: () -> Void

    @State private var glow = false
    @State private var pulse = false
    @State private var sparkle = false

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }) {
            ZStack {
                // MARK: - 1. Основа кнопки (стеклянный градиент)
                RoundedRectangle(cornerRadius: 35, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.indigo.opacity(0.9),
                                Color(red: 160/255, green: 90/255, blue: 255/255).opacity(0.9)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 35)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.9),
                                        Color.indigo.opacity(0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: Color.purple.opacity(glow ? 0.9 : 0.4), radius: glow ? 25 : 8)
                    .blur(radius: pulse ? 0.6 : 0)

                // MARK: - 2. Светящийся “аура” фон
                RoundedRectangle(cornerRadius: 35)
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.indigo.opacity(0.5),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 5,
                            endRadius: 120
                        )
                    )
                    .scaleEffect(glow ? 1.2 : 0.9)
                    .opacity(glow ? 0.9 : 0.3)
                    .blur(radius: glow ? 25 : 10)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: glow)

                // MARK: - 3. Контент (иконка + текст)
                HStack(spacing: 10) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.title2.weight(.semibold))
                            .shadow(color: .white.opacity(0.5), radius: 2, x: 0, y: 1)
                    }
                    Text(title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .shadow(color: .white.opacity(0.3), radius: 2, x: 0, y: 1)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 36)
                .padding(.vertical, 18)

                // MARK: - 4. Мягкое блуждающее свечение внутри
                RoundedRectangle(cornerRadius: 35)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(sparkle ? 0.9 : 0.2),
                                Color.indigo.opacity(0.1),
                                Color.white.opacity(0.9)
                            ],
                            startPoint: sparkle ? .bottomTrailing : .topLeading,
                            endPoint: sparkle ? .topLeading : .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .blur(radius: 3)
                    .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: sparkle)
            }
            .frame(maxWidth: 280, maxHeight: 70)
            .shadow(color: .indigo.opacity(glow ? 0.8 : 0.4), radius: glow ? 30 : 12, x: 0, y: 12)
        }
        .onAppear {
            glow = true
            pulse = true
            sparkle = true
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [.black, .purple.opacity(0.7)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        MagicStartButton(title: "Start Game", icon: "gamecontroller.fill") {
            print("Start pressed")
        }
    }
    .preferredColorScheme(.dark)
}
