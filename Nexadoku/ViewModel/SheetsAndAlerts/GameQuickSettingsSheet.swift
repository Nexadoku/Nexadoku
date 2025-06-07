
import SwiftUI

struct GameQuickSettingsSheet: View {
    
    @AppStorage("soundEnabled") private var soundEnabled: Bool = true
    @AppStorage("vibrationEnabled") private var vibrationEnabled: Bool = true
    @AppStorage("timerEnabled") private var timerEnabled: Bool = true
    @AppStorage("mistakesEnabled") private var mistakesEnabled: Bool = true
    @AppStorage("highlightsEnabled") private var highlightsEnabled: Bool = true
    @AppStorage("highlightLinesEnabled") private var highlightLinesEnabled: Bool = false
    @AppStorage("isPremium") private var isPremium: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .frame(width: 44, height: 6)
                .foregroundColor(.gray.opacity(0.3))
                .padding(.top, 14)
            
            Text("Quick Settings")
                .font(.title2.bold())
                .foregroundColor(.purple)
            
            Toggle("Sounds", isOn: $soundEnabled)
                .foregroundColor(.white)
                .toggleStyle(SwitchToggleStyle(tint: .purple))
            Toggle("Vibration", isOn: $vibrationEnabled)
                .foregroundColor(.white)
                .toggleStyle(SwitchToggleStyle(tint: .purple))
            Toggle("Mistake Limit", isOn: $mistakesEnabled)
                .foregroundColor(.white)
                .toggleStyle(SwitchToggleStyle(tint: .purple))
            Toggle("Timer", isOn: $timerEnabled)
                .foregroundColor(.white)
                .toggleStyle(SwitchToggleStyle(tint: .purple))
            Toggle("Highlight Duplicates", isOn: $highlightsEnabled)
                .foregroundColor(.white)
                .toggleStyle(SwitchToggleStyle(tint: .purple))
            Toggle("Highlight Lines", isOn: $highlightLinesEnabled)
                .foregroundColor(.white)
                .toggleStyle(SwitchToggleStyle(tint: isPremium ? .purple : .gray))
                .disabled(!isPremium)
            
            Spacer()
            
            Button("Close") {
                dismiss()
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(.purple)
            .cornerRadius(18)
            .padding(.bottom, 18)
        }
        .padding()
        .background(
            DarkBackground()
        )
        .presentationDetents([.medium, .large])
    }
}
