import SwiftUI

struct WinScreen: View {
    var onExit: () -> Void
    var timeElapsed: Int
    var mistakes: Int
    
    @EnvironmentObject private var navigator: Navigator
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("mistakesEnabled") var mistakesEnabled: Bool = true
    @AppStorage("timerEnabled") var timerEnabled: Bool = true
    
    private let fireworkColors: [Color] = [.white, .yellow, .purple, .pink]
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        ZStack {
            SystemDarkBackground().blur(radius: 4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                Text("Congratulations!")
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                Text("You Win!")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.white)
                
                // Капсула, только если хотя бы один активен
                if mistakesEnabled || timerEnabled {
                    HStack(spacing: 0) {
                        if timerEnabled {
                            VStack {
                                Text(timeFormatted(timeElapsed))
                                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                                    .foregroundColor(.green)
                                    .shadow(color: .black, radius: 1)
                                Text("Time")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        if timerEnabled && mistakesEnabled {
                            Divider()
                                .frame(height: 70)
                                .background(Color.white)
                        }
                        
                        if mistakesEnabled {
                            VStack {
                                Text("Mistakes: \(mistakes)/3")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.red)
                                    .shadow(color: .black, radius: 1)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(
                        LinearGradient(colors: [.purple.opacity(0.3), .black.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .padding(.horizontal)
                    .shadow(radius: 10)
                }
                
                Spacer()
                
                Button(action: {
                    navigator.pop()
                }) {
                    Text("Return to Main Menu")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 30)
                        .background(.purple)
                        .cornerRadius(26)
                        .shadow(color: .purple, radius: 10)
                        .padding(.bottom, 100)
                }
                .padding(.top, 20)
            }
        }
    }
}

struct WinScreen_Previews: PreviewProvider {
    static var previews: some View {
        WinScreen(onExit: {}, timeElapsed: 123, mistakes: 1)
            .environmentObject(Navigator())
            .preferredColorScheme(.dark)
    }
}


