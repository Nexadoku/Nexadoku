
import SwiftUI

struct BadgeView: View {
    let count: Int
    
    var body: some View {
        Text("\(count)")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.purple)
            .padding(.vertical, 2)
            .padding(.horizontal, 8)
            .background(
                Capsule().fill(Color.white)
            )
            .shadow(radius: 6)
    }
}
