
import SwiftUI

struct PauseOverlay: View {
    
    let level: DifficultyLevel
    let mistakes: Int
    let pausedTime: Int
    let onResume: () -> Void
    let onRestart: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("paused")
                .font(.system(size: 40, weight: .heavy))
                .foregroundStyle(LinearGradient(colors: [.white, .white.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            VStack(spacing: 16) {
                overlayItem(title: "Level", value: level.rawValue)
                Divider().background(Color.white.opacity(0.4))
                overlayItem(title: "Mistakes", value: "\(mistakes)/3")
                Divider().background(Color.white.opacity(0.4))
                overlayItem(title: "Time", value: timeFormatted(pausedTime))
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 24)
            .background(
                LinearGradient(
                    colors: [.black.opacity(0.4), .purple.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.purple, lineWidth: 1.5)
                   )
            .cornerRadius(30)
            )
            
            HStack(spacing: 20) {
                AppButton(text: "Resume") {
                    withAnimation {
                        onResume()
                        VibrationManager.shared.lightImpact()
                    }
                }
                .appButtonVariation(.primary)
                
                AppButton(text: "Restart") {
                    onRestart()
                    VibrationManager.shared.lightImpact()
                }
                .appButtonVariation(.destructive)
            }
        }
        .padding()
        .transition(.opacity)
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
