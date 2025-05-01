import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("vibrationEnabled") private var vibrationEnabled = true
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("timerEnabled") private var timerEnabled = true
    @AppStorage("mistakesEnabled") private var mistakesEnabled = true
    @EnvironmentObject var languageSettings: LanguageSettings
    
    var body: some View {
        ZStack {
            SystemDarkBackground()
            VStack {
                ScrollView {
                    VStack(spacing: 30) {
                        HStack {
                            Button {
                                dismiss()
                                VibrationManager.shared.lightImpact()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .heavy))
                            }
                            Text("SETTINGS")
                                .font(.system(size: 30, weight: .heavy))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding()
                        
                        VStack(alignment: .leading, spacing: 10) {
                                Text("General Settings")
                                .padding(.horizontal)
                                .font(.system(size: 17, weight: .heavy))
                                .foregroundColor(.gray)
                            
                            VStack {
                                Toggle(isOn: $soundEnabled) {
                                    Text("sound")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .purple))
                                .padding()
                                
                                Toggle(isOn: $vibrationEnabled) {
                                    Text("vibration")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .purple))
                                .padding()
                            }
                            .background(
                                LinearGradient(colors: [.purple.opacity(0.3), .black.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(25)
                            .padding()
                            
                            Text("Game Settings")
                                .padding(.horizontal)
                                .font(.system(size: 17, weight: .heavy))
                                .foregroundColor(.gray)
                            
                            VStack {
                                Toggle(isOn: $timerEnabled) {
                                    Text("Timer")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .purple))
                                .padding()
                                
                                Toggle(isOn: $mistakesEnabled) {
                                    Text("Mistakes")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .purple))
                                .padding()
                            }
                            .background(
                                LinearGradient(colors: [.purple.opacity(0.3), .black.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(25)
                            .padding()
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SettingsViewPreviews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Navigator())
            .environmentObject(LanguageSettings())
    }
}
