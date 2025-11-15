
import SwiftUI

struct PremiumCrownIcon: View {
    @State private var glow = false
    @State private var rotate = false
    @State private var shimmer = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 150/255, green: 80/255, blue: 255/255).opacity(glow ? 0.55 : 0.25),
                            .clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 50
                    )
                )
                .blur(radius: 16)
                .scaleEffect(glow ? 1.25 : 0.9)
                .animation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true), value: glow)
            
            AngularGradient(
                colors: [
                    Color.white.opacity(0.9),
                    Color(red: 140/255, green: 60/255, blue: 255/255),
                    Color.white.opacity(0.9),
                    Color(red: 60/255, green: 20/255, blue: 120/255)
                ],
                center: .center
            )
            .mask(
                Image(systemName: "crown.fill")
                    .resizable()
                    .scaledToFit()
            )
            .rotationEffect(.degrees(rotate ? 360 : 0))
            .animation(.linear(duration: 8).repeatForever(autoreverses: false), value: rotate)
            .shadow(color: .white.opacity(0.3), radius: 4)
            .shadow(color: Color.purple.opacity(0.4), radius: 8, x: 0, y: 4)
            
            RoundedRectangle(cornerRadius: 50)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.25),
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: shimmer ? 80 : 0, height: shimmer ? 80 : 0)
                .blur(radius: 6)
                .mask(
                    Image(systemName: "crown.fill")
                        .resizable()
                        .scaledToFit()
                )
                .animation(
                    .easeInOut(duration: 3)
                    .repeatForever(autoreverses: true)
                    .delay(1.5),
                    value: shimmer
                )
        }
        .onAppear {
            glow = true
            rotate = true
            shimmer = true
        }
        .scaleEffect(1.05)
    }
}
