
import SwiftUI

struct PauseOverlay: View {
    
    let level: DifficultyLevel
    let mistakes: Int
    let pausedTime: Int
    let onResume: () -> Void
    let onRestart: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("PAUSED")
                .font(.system(size: 40, weight: .heavy))
                .foregroundStyle(LinearGradient(colors: [.white], startPoint: .topLeading, endPoint: .bottomTrailing))
             
            VStack(spacing: 16) {
                overlayItem(title: "Level", value: level.rawValue)
                overlayItem(title: "Mistakes", value: "\(mistakes)/3")
                overlayItem(title: "Time", value: timeFormatted(pausedTime))
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 24)
            .background(
                LinearGradient(colors: [.black.opacity(0.5), .purple.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.purple, lineWidth: 3)
                   )
            .cornerRadius(30)
            
            HStack {
                Button(action: {
                    onResume()
                    VibrationManager.shared.lightImpact()
                }) {
                    Text("Continue")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 16)
                        .background(.purple)
                        .clipShape(Capsule())
                }
                
                Button(action: {
                    onRestart()
                    VibrationManager.shared.lightImpact()
                }) {
                    Text("Restart")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 16)
                        .background(.purple)
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
