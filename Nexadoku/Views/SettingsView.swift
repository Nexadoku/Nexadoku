import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("vibrationEnabled") private var vibrationEnabled = true
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("timerEnabled") private var timerEnabled = true
    @AppStorage("mistakesEnabled") private var mistakesEnabled = true
    @AppStorage("highlightsEnabled") private var highlightsEnabled = false
    @AppStorage("isPremium") private var isPremium = true
    
    @EnvironmentObject var languageSettings: LanguageSettings
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
           DarkBackground()
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
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(LinearGradient(colors: [.purple, .purple], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
                            )
                            
                            .padding()
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Toggle(isOn: $mistakesEnabled) {
                                    Text("Mistake Limit")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .purple))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(LinearGradient(colors: [.purple, .purple], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
                                )
                                
                                Text("Limit the number of possible mistakes to 3 per game")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.system(size: 15))
                                    .padding()
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Toggle(isOn: $highlightsEnabled) {
                                    Text("Highlight Duplicates")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: isPremium ? .purple : .gray))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.purple, lineWidth: 1.5)
                                )
                                .disabled(!isPremium)
                                
                                if !isPremium {
                                    Text("Highlighting is avilable only for Premum users.")
                                        .font(.system(size: 14))
                                        .foregroundColor(.yellow)
                                        .padding()
                                } else {
                                    Text("Highlight repeating numbers in each row, column, and block.")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.1), value: animate)
            }
            .onAppear {
                animate = true
                if !isPremium {
                    highlightsEnabled = false
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
