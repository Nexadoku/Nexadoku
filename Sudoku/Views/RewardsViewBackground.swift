
import SwiftUI

struct RewardsViewBackground: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            BlurView(style: .systemChromeMaterialDark)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct RewardsViewBackgroundPreviews: PreviewProvider {
    static var previews: some View {
        RewardsViewBackground()
    }
}
