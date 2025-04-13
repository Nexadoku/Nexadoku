
import SwiftUI

struct PauseOverlay: View {
    
    let level: DifficultyLevel
    let mistakes: Int
    let pausedTime: Int
    let onResume: () -> Void
    let onRestart: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Paused")
                .font(.system(size: 40, weight: .heavy))
                .foregroundStyle(LinearGradient(colors: [.white, .white.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 16) {
                overlayItem(title: "Level", value: level.rawValue)
                Divider().background(Color.white.opacity(0.4))
                overlayItem(title: "Mistakes", value: "\(mistakes)/3")
                Divider().background(Color.white.opacity(0.4))
                overlayItem(title: "Time", value: timeFormatted(pausedTime))
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 24)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(LinearGradient(colors: [.purple.opacity(0.6), .indigo.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
                   
            )
            .shadow(color: .purple, radius: 10)
            .shadow(color: .indigo, radius: 10)
            
            HStack {
                Button(action: onResume) {
                    Text("Continue")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 16)
                        .background(LinearGradient(colors: [.purple, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .clipShape(Capsule())
                }
                
                Button(action: onRestart) {
                    Text("Restart")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 16)
                        .background(LinearGradient(colors: [.purple, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
    }
    
    private func overlayItem(title: String, value: String) -> some View {
        HStack {
            Text(title + ":")
                .font(.headline.weight(.semibold))
                .foregroundColor(.white.opacity(0.8))
            Spacer()
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
        }
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
