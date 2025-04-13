
import SwiftUI

struct WinScreen: View {
    var onExit: () -> Void
    var timeElapsed: Int
    var mistakes: Int
    
    @State private var animate = false
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        ZStack {
            LuxuriousDarkBackgroundView()
            VStack(spacing: 40) {
                Text("💫 Congratulations! 💫")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(colors: [.indigo, .purple], startPoint: .topTrailing, endPoint: .bottomLeading)
                    )
                    .scaleEffect(animate ? 1.1 : 0.9)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animate)
                
                Text("🎉 You completed the level 🎉")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.white)
                    
                
                VStack {
                    Text(timeFormatted(timeElapsed))
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .foregroundColor(.green)
                        .shadow(color: .black, radius: 2)
                        .padding()
                    
                    Text("Mistakes: \(mistakes)/3")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.red)
                        .padding(.top, -20)
                        .padding()
                }
                
                Button(action: onExit) {
                    Text("Main Menu")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(20)
                        .shadow(color: .indigo, radius: 10)
                        .shadow(color: .purple, radius: 10)
                }
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct WinScreen_Previews: PreviewProvider {
    static var previews: some View {
        WinScreen(
            onExit: {},
            timeElapsed: 187,  // например, 3 минуты 7 секунд
            mistakes: 2
        )
        .preferredColorScheme(.dark)
    }
}

