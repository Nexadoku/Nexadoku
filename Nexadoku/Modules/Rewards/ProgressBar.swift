
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
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 140/255, green: 60/255, blue: 255/255),
                                Color(red: 60/255, green: 20/255, blue: 120/255)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .opacity(0.95)
                    )
                    .frame(width: geometry.size.width * progress)
            }
        }
    }
}
