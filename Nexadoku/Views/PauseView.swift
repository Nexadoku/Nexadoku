
import SwiftUI

struct PauseView: View {
    let level: DifficultyLevel
    let mistakes: Int
    let timeElapsed: Int
    let onResume: () -> Void
    let onRestart: () -> Void
    let onExit: () -> Void
    
    @State private var animateElements = false
    @State private var glowEffect = false
    
    var body: some View {
        ZStack {
            // Beautiful gradient background
            SystemBackground()
            
            VStack(spacing: 40) {
                // PAUSED Title with beautiful styling
                VStack(spacing: 8) {
                    Text("PAUSED")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(red: 140/255, green: 60/255, blue: 255/255))
                        .scaleEffect(animateElements ? 1.0 : 0.8)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateElements)
                    
                    Text("Game Statistics")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .scaleEffect(animateElements ? 1.0 : 0.8)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateElements)
                }
                
                // Game Statistics Card in the same GlassPanel style
                GlassPanel {
                    VStack(spacing: 16) {
                        StatCard(
                            icon: "gamecontroller.fill",
                            title: "Level",
                            value: level.rawValue,
                            color: .white
                        )
                        .scaleEffect(animateElements ? 1.0 : 0.9)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateElements)

                        StatCard(
                            icon: "clock.fill",
                            title: "Time",
                            value: timeFormatted(timeElapsed),
                            color: .white
                        )
                        .scaleEffect(animateElements ? 1.0 : 0.9)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateElements)

                        StatCard(
                            icon: "exclamationmark.triangle.fill",
                            title: "Mistakes",
                            value: "\(mistakes)/3",
                            color: mistakes >= 2 ? .red : mistakes == 1 ? .orange : .green
                        )
                        .scaleEffect(animateElements ? 1.0 : 0.9)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateElements)
                    }
                    .padding(18)
                }
                .padding(.horizontal, 24)
                
                // Action Buttons
                VStack(spacing: 16) {
                    // Resume Button
                    ActionButton(
                        title: "Continue Game",
                        icon: "play.fill",
                        color: Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.8),
                        action: onResume
                    )
                    .scaleEffect(animateElements ? 1.0 : 0.8)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateElements)
                    
                    // Restart Button
                    ActionButton(
                        title: "Restart Game",
                        icon: "arrow.clockwise",
                        color: .indigo.opacity(0.8),
                        action: onRestart
                    )
                    .scaleEffect(animateElements ? 1.0 : 0.8)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: animateElements)
                    
                    // Exit Button
                    ActionButton(
                        title: "Exit to Menu",
                        icon: "house.fill",
                        color: .red.opacity(0.8),
                        action: onExit
                    )
                    .scaleEffect(animateElements ? 1.0 : 0.8)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.8), value: animateElements)
                }
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            withAnimation {
                animateElements = true
                glowEffect = true
            }
        }
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            VibrationManager.shared.lightImpact()
            action()
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.3), .white.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

struct PauseView_Previews: PreviewProvider {
    static var previews: some View {
        PauseView(
            level: .medium,
            mistakes: 1,
            timeElapsed: 125,
            onResume: {},
            onRestart: {},
            onExit: {}
        )
        .preferredColorScheme(.dark)
    }
}
