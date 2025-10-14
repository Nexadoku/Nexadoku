import SwiftUI

struct QuickSettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @AppStorage("soundEnabled") private var soundEnabled: Bool = true
    @AppStorage("vibrationEnabled") private var vibrationEnabled: Bool = true
    @AppStorage("timerEnabled") private var timerEnabled: Bool = true
    @AppStorage("mistakesEnabled") private var mistakesEnabled: Bool = true
    @AppStorage("highlightsEnabled") private var highlightsEnabled: Bool = true
    @AppStorage("highlightLinesEnabled") private var highlightLinesEnabled: Bool = false
    @AppStorage("isPremium") private var isPremium: Bool = false

    @State private var appear = false

    var body: some View {
        ZStack {
            DarkBackground()

            VStack(spacing: 22) {
                HStack {
                    Text("QUICK SETTINGS")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        VibrationManager.shared.lightImpact()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.08))
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)

                GlassPanel {
                    VStack(spacing: 0) {
                        // Top illustrative image
                        Image("GlassPanel")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 8)

                        // Divider line with slight translucency
                        Rectangle()
                            .fill(Color.white.opacity(0.08))
                            .frame(height: 1)

                        // Toggles
                        VStack(alignment: .leading, spacing: 14) {
                        toggleRow(title: "Sounds", binding: $soundEnabled)
                        toggleRow(title: "Vibration", binding: $vibrationEnabled)
                        toggleRow(title: "Mistake Limit", binding: $mistakesEnabled)
                        toggleRow(title: "Timer", binding: $timerEnabled)
                        toggleRow(title: "Highlight Duplicates", binding: $highlightsEnabled)
                        HStack {
                            Text("Highlight Lines")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                            Toggle("", isOn: $highlightLinesEnabled)
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: isPremium ? .purple : .gray))
                                .disabled(!isPremium)
                        }
                        }
                        .padding(14)
                    }
                }
                .padding(.horizontal)
                .scaleEffect(appear ? 1 : 0.9)
                .opacity(appear ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.85), value: appear)

                Spacer()
            }
            .padding(.top, 20)
        }
        .onAppear { appear = true }
    }

    private func toggleRow(title: String, binding: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
            Toggle("", isOn: binding)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .purple))
        }
    }
}

struct GlassPanel<Content: View>: View {
    var content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) { self.content = content }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
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
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.25), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
                .blendMode(.screen)
            RoundedRectangle(cornerRadius: 22)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.85), Color.white.opacity(0.25)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.purple.opacity(0.35), lineWidth: 0.6)
                .blur(radius: 2)
                .offset(x: -1, y: -1)
                .opacity(0.6)
        )
        .overlay(content())
    }
}


