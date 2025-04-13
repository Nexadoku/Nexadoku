
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("vibrationEnabled") private var vibrationEnabled = true
    @AppStorage("soundEnabled") private var soundEnabled = true
    
    var body: some View {
        ZStack {
            LuxuriousDarkBackgroundView()
            VStack {
                ScrollView {
                    VStack(spacing: 30) {
                        
                        Text("Settings")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 40)
                        
                        VStack(spacing: 10) {
                            Toggle(isOn: $soundEnabled) {
                                Text("Sound")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .purple))
                            .padding()
                            
                            Toggle(isOn: $vibrationEnabled) {
                                Text("Vibration")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .purple))
                            .padding()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
