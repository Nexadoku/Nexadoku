
import SwiftUI

struct FeatureRow: View {
    let feature: PremiumFeature
    var icon: String = "star.fill"

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color(red: 140/255, green: 60/255, blue: 255/255))
                    .shadow(color: Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.7), radius: 18, x: 0, y: 8)
                    .font(.system(size: 20, weight: .bold))
                Text(feature.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            Text(feature.description)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.8))
                .padding(.leading, 34)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
