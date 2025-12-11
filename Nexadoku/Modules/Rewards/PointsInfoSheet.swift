
import SwiftUI

struct PointsAlert: View {
    var onClose: () -> Void
    
    @State private var appear = false
    @State private var coinGlow = false
    @State private var textAppear = false

    var body: some View {
        ZStack {
            glassBackground
            
            VStack(spacing: 20) {
                // Coin with animated glow
                ZStack {
                    Image("coin")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                        .shadow(color: .white.opacity(coinGlow ? 0.2 : 0.08), radius: coinGlow ? 20 : 10)
                        .scaleEffect(appear ? 1 : 0.8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: appear)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: coinGlow)
                }
                
                Text("WHAT ARE POINTS?")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(.white)
                    .opacity(textAppear ? 1 : 0)
                    .offset(y: textAppear ? 0 : 20)
                    .animation(.easeInOut(duration: 0.4).delay(0.2), value: textAppear)
                
                
                VStack(spacing: 16) {
                    Text("""
Earn points by unlocking trophies!

• Bronze Trophy: +10 points  
• Silver Trophy: +30 points  
• Gold Trophy: +60 points

Points are kept forever and show your progress.
""")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.9))
                    .font(.system(size: 16, weight: .regular))
                    .lineSpacing(4)
                    .opacity(textAppear ? 1 : 0)
                    .offset(y: textAppear ? 0 : 30)
                    .animation(.easeInOut(duration: 0.4).delay(0.4), value: textAppear)
                    
                    // Coming soon section with special styling
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "sparkles")
                            .foregroundColor(Color(red: 140/255, green: 60/255, blue: 255/255))
                                .font(.system(size: 16, weight: .bold))
                            Text("Coming Soon")
                                .foregroundColor(Color(red: 140/255, green: 60/255, blue: 255/255))
                                .font(.system(size: 16, weight: .bold))
                            Image(systemName: "sparkles")
                                .foregroundColor(Color(red: 140/255, green: 60/255, blue: 255/255))
                                .font(.system(size: 16, weight: .bold))
                        }
                        
                        Text("You'll be able to spend points on exclusive content, customization, and more!")
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 140/255, green: 60/255, blue: 255/255))
                            .font(.system(size: 14, weight: .medium))
                            .lineSpacing(2)
                    }
                    .opacity(textAppear ? 1 : 0)
                    .offset(y: textAppear ? 0 : 30)
                    .animation(.easeInOut(duration: 0.4).delay(0.6), value: textAppear)
                }
                .padding(.horizontal, 20)
                
                // Glass close button
                Button(action: onClose) {
                    Text("Close")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(glassButton)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding(.horizontal, 20)
                .opacity(textAppear ? 1 : 0)
                .offset(y: textAppear ? 0 : 30)
                .animation(.easeInOut(duration: 0.4).delay(0.8), value: textAppear)
            }
            .padding(.vertical, 32)
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: 380)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .scaleEffect(appear ? 1 : 0.9)
        .opacity(appear ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: appear)
        .onAppear {
            appear = true
            coinGlow = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                textAppear = true
            }
        }
    }
    
    private var glassBackground: some View {
        ZStack {
            // Base glass gradient (new palette)
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.42),
                            Color(red: 60/255, green: 20/255, blue: 120/255).opacity(0.42)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Top highlight
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.25), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
                .blendMode(.screen)
            
            // Secondary highlight for depth
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    RadialGradient(
                        colors: [Color.white.opacity(0.15), Color.clear],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 120
                    )
                )
                .blendMode(.overlay)
            
            // Glass border
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.8),
                            Color.white.opacity(0.2),
                            Color.purple.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
            
            // Outer glow
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.35), lineWidth: 0.8)
                .blur(radius: 3)
                .offset(x: -1, y: -1)
                .opacity(0.7)
        }
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 12)
        .shadow(color: .white.opacity(0.06), radius: 6, x: -2, y: -2)
    }
    
    private var glassButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.18),
                            Color.white.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.4), lineWidth: 1)
        }
    }
}
