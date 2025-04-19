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
                        Text("settings")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 40)
                        
                        VStack(alignment: .leading, spacing: 10) {
                                Text("General settings")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 17))
                                    .padding(.horizontal)
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
                           

                            Picker(NSLocalizedString("language", comment: ""), selection: $languageSettings.currentLanguage) {
                                Text("english").tag(Language.english)
                                Text("russian").tag(Language.russian)
                            }
                            .pickerStyle(.segmented)
                            .padding()
                            }
                            Text("Game settings")
                                .foregroundColor(.gray)
                                .font(.system(size: 17))
                                .padding(.horizontal)
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
                        }
                    }
                }
            }
        }
    }
}

struct SettingsViewPreviews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Navigator())
            .environmentObject(LanguageSettings())
    }
}
