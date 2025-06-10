
import SwiftUI

struct ProgressBar: View {
    var current: Int
    var total: Int
    
    var progress: CGFloat {
        guard total > 0 else { return 0 }
        return min(1.0, CGFloat(current) / CGFloat(total))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.15))
                Capsule()
                    .fill(progress >= 1 ? Color.indigo : Color.indigo.opacity(0.8))
                    .frame(width: geometry.size.width * progress)
            }
        }
    }
}
