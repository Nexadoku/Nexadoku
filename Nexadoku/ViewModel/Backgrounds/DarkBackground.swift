
import SwiftUI

struct DarkBackground: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            BlurView(style: .systemChromeMaterialDark)
                .edgesIgnoringSafeArea(.all)
            
            ForEach(0..<50, id: \.self) { index in
                Text("\(Int.random(in: 1...9))")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(Color.purple.opacity(0.2))
                    .rotationEffect(.degrees(Double.random(in: 0...360)))
                    .position(x: CGFloat.random(in: 0...UIScreen.main.bounds.width), y: CGFloat.random(in: 0...UIScreen.main.bounds.height))
            }
        }
    }
}

struct RewardsViewBackgroundPreviews: PreviewProvider {
    static var previews: some View {
        DarkBackground()
    }
}
