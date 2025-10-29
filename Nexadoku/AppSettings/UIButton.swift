
import SwiftUI

struct GlassPurpleButton: View {
    var title: String
    var icon: String? = nil
    var action: () -> Void
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 10) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.title2.weight(.semibold))
                }
                
                Text(title)
                    .font(.title2.bold())
            }
            .foregroundColor(.white)
            .padding(.horizontal, 40)
            .padding(.vertical, 18)
            .frame(maxWidth: 500)
            .background(
                ZStack {
                    // Base solid background with subtle gradient
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.purple.opacity(0.8),
                                    Color.purple.opacity(0.6),
                                    Color.purple.opacity(0.7)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Top-left highlight (light source from top-left)
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .center
                            )
                        )
                    
                    // Bottom-right shadow (darker edge)
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.black.opacity(0.1),
                                    Color.black.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Inner border highlight
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0.1),
                                    Color.black.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            // Optimized neumorphic shadows
            .shadow(color: .black.opacity(0.15), radius: 6, x: 3, y: 3)
            .shadow(color: .white.opacity(0.2), radius: 4, x: -2, y: -2)
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPressed)
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

#Preview {
    ZStack {
       SystemBackground()
        
        VStack(spacing: 28) {
            GlassPurpleButton(title: "Play", icon: "gamecontroller.fill") {
                print("tapped")
            }
            .padding()
            
        }
        .preferredColorScheme(.dark)
    }
}
