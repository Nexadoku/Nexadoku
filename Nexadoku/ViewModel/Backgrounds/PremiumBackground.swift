
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
            LinearGradient(colors: [.black, .purple], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            BlurView(style: .systemChromeMaterialDark)
                .edgesIgnoringSafeArea(.all)
            
            // Рисуем 50 рандомных звезд
            ForEach(stars) { star in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: star.size, height: star.size)
                    .foregroundColor(Color.purple.opacity(star.opacity))
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
