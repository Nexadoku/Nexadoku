
import SwiftUI

struct StarBackgroundStar: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let angle: Double
    let opacity: Double
}

struct PremiumBackground: View {
    let stars: [StarBackgroundStar] = (0..<50).map { _ in
        StarBackgroundStar(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
            size: CGFloat.random(in: 24...70),
            angle: Double.random(in: 0...360),
            opacity: Double.random(in: 0.08...0.23)
        )
    }
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                colors: [
                    Color(red: 15/255, green: 6/255, blue: 28/255),
                    Color(red: 10/255, green: 5/255, blue: 20/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            LinearGradient(
                colors: [
                    Color(red: 168/255, green: 61/255, blue: 255/255).opacity(0.45),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .center
            )
            .blendMode(.screen)
            .ignoresSafeArea()

            RadialGradient(
                colors: [
                    Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.38),
                    Color.clear
                ],
                center: .bottom,
                startRadius: 10,
                endRadius: 520
            )
            .blendMode(.screen)
            .ignoresSafeArea()

            Group {
                Circle()
                    .fill(Color(red: 190/255, green: 80/255, blue: 255/255).opacity(0.25))
                    .frame(width: 320, height: 320)
                    .offset(x: -180, y: -260)
                    .blur(radius: 90)

                Circle()
                    .fill(Color(red: 95/255, green: 120/255, blue: 255/255).opacity(0.22))
                    .frame(width: 280, height: 280)
                    .offset(x: 200, y: 280)
                    .blur(radius: 100)
            }
            .allowsHitTesting(false)

            LinearGradient(
                colors: [Color.black.opacity(0.38), Color.clear, Color.black.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottom
            )
            .blendMode(.multiply)
            .ignoresSafeArea()
            
            ForEach(stars) { star in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: star.size, height: star.size)
                    .foregroundColor(Color(red: 140/255, green: 60/255, blue: 255/255)).opacity(0.1)
                    .rotationEffect(.degrees(star.angle))
                    .position(x: star.x, y: star.y)
            }
        }
    }
}

struct PremiumBackgroundPreviews: PreviewProvider {
    static var previews: some View {
        PremiumBackground()
    }
}
