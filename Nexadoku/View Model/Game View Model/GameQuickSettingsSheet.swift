
import SwiftUI

struct GameQuickSettingsSheet: View {
    
    @AppStorage("soundEnabled") private var soundEnabled: Bool = true
    @AppStorage("vibrationEnabled") private var vibrationEnabled: Bool = true
    @AppStorage("timerEnabled") private var timerEnabled: Bool = true
    @AppStorage("mistakesEnabled") private var mistakesEnabled: Bool = true
    @AppStorage("highlightsEnabled") private var highlightsEnabled: Bool = true
    @AppStorage("highlightLinesEnabled") private var highlightLinesEnabled: Bool = false
    @AppStorage("isPremium") private var isPremium: Bool = false
    var onClose: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("QUICK SETTINGS")
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
            
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
            
        }
        .padding(22)
    }
}
