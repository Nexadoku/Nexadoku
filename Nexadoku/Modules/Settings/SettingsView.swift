import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("vibrationEnabled") private var vibrationEnabled = true
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("timerEnabled") private var timerEnabled = true
    @AppStorage("mistakesEnabled") private var mistakesEnabled = true
    @AppStorage("highlightsEnabled") private var highlightsEnabled = true
    @AppStorage("highlightLinesEnabled") private var highlightLinesEnabled = false
    @AppStorage("isPremium") private var isPremium = false

    @EnvironmentObject var languageSettings: LanguageSettings
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
           SystemBackground()
            VStack {
                ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 28, weight: .heavy))
                                    .foregroundColor(.white)
                                
                                Text("Settings")
                                    .font(.system(size: 28, weight: .heavy))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            
                            VStack {
                                Toggle(isOn: $soundEnabled) {
                                    Text("Sounds")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: Color(red: 140/255, green: 60/255, blue: 255/255)))
                                .padding()
                                
                                Toggle(isOn: $vibrationEnabled) {
                                    Text("Vibration")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: Color(red: 140/255, green: 60/255, blue: 255/255)))
                                .padding()
                                
                                Toggle(isOn: $timerEnabled) {
                                    Text("Timer")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: Color(red: 140/255, green: 60/255, blue: 255/255)))
                                .padding()
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(LinearGradient(colors: [Color(red: 140/255, green: 60/255, blue: 255/255)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                                    .background(
                                        LinearGradient(colors: [Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.4), .black.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .cornerRadius(20)
                            )
                            
                            .padding()
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Toggle(isOn: $mistakesEnabled) {
                                    Text("Mistake Limit")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: Color(red: 140/255, green: 60/255, blue: 255/255)))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(LinearGradient(colors: [Color(red: 140/255, green: 60/255, blue: 255/255)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                                        .background(
                                            LinearGradient(colors: [Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.4), .black.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        )
                                        .cornerRadius(20)
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
                                .toggleStyle(SwitchToggleStyle(tint: Color(red: 140/255, green: 60/255, blue: 255/255)))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(red: 140/255, green: 60/255, blue: 255/255), lineWidth: 1)
                                        .background(
                                            LinearGradient(colors: [Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.4), .black.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        )
                                        .cornerRadius(20)
                                )
                                    Text("Highlight repeating numbers in each row, column, and block.")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding()
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Toggle(isOn: $highlightLinesEnabled) {
                                    Text("Highlight Lines")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: isPremium ? Color(red: 140/255, green: 60/255, blue: 255/255) : .gray))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(red: 140/255, green: 60/255, blue: 255/255), lineWidth: 1)
                                        .background(
                                            LinearGradient(colors: [Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.4), .black.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        )
                                        .cornerRadius(20)
                                )
                                .disabled(!isPremium)
                                
                                if !isPremium {
                                    Text("Highlighting Lines is available only for Premium users.")
                                        .font(.system(size: 15))
                                        .foregroundColor(.yellow)
                                        .padding()
                                } else {
                                    Text("Highlight Lines repeating numbers in each row, column, and line.")
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
        
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                    VibrationManager.shared.lightImpact()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                    
                    Text("Back")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(.white)
                }
            }
        }
        .toolbarBackground(Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.3), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct SettingsViewPreviews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Navigator())
            .environmentObject(LanguageSettings())
    }
}


