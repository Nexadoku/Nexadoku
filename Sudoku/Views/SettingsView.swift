import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("vibrationEnabled") private var vibrationEnabled = true
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("timerEnabled") private var timerEnabled = true
    @AppStorage("mistakesEnabled") private var mistakesEnabled = true
    @EnvironmentObject var languageSettings: LanguageSettings
    
    @State private var animate = false
    
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
                            VStack {
                                Toggle(isOn: $soundEnabled) {
                                    Text("Sounds")
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
                                
                                Toggle(isOn: $timerEnabled) {
                                    Text("Timer")
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
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Toggle(isOn: $mistakesEnabled) {
                                    Text("Mistake Limit")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .purple))
                                .padding()
                                
                                Text("Limit the number of possible mistakes to 3 per game")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.system(size: 15))
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
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 20)
                .animation(.easeOut(duration: 1.0).delay(0.2), value: animate)
            }
            .onAppear {
                animate = true
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
