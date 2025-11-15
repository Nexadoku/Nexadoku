
import SwiftUI

struct PremiumCrownIcon: View {
    @State private var shimmerPhase: CGFloat = 0
    @State private var gradientShift: CGFloat = 0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.purple.opacity(0.4),
                            Color(red: 60/255, green: 20/255, blue: 120/255).opacity(0.1),
                            .clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 80
                    )
                )
                .blur(radius: 25)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.05), lineWidth: 0.8)
                        .blur(radius: 1)
                )
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 170/255, green: 100/255, blue: 255/255),
                    Color.white.opacity(0.95),
                    Color(red: 100/255, green: 40/255, blue: 255/255)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .hueRotation(.degrees(gradientShift))
            .mask(
                Image("premium")
                    .resizable()
                    .scaledToFit()
            )
            .shadow(color: Color.white.opacity(0.25), radius: 6)
            .shadow(color: Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.6), radius: 10)
            .overlay(
                AngularGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.0),
                        Color.yellow.opacity(0.18),
                        Color.white.opacity(0.0)
                    ]),
                    center: .center,
                    startAngle: .degrees(shimmerPhase),
                    endAngle: .degrees(shimmerPhase + 180)
                )
                .mask(
                    Image("premium")
                        .resizable()
                        .scaledToFit()
                )
                .blur(radius: 1.2)
            )
        }
        .onAppear {
            withAnimation(.linear(duration: 18).repeatForever(autoreverses: false)) {
                gradientShift = 360
            }
            
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: false)) {
                shimmerPhase = 720
            }
        }
        .frame(width: 42, height: 42)
        .scaleEffect(1.0)
    }
}
