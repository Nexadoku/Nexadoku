
import SwiftUI

struct SettingsBackground: View {
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
        SettingsBackground()
    }
}
