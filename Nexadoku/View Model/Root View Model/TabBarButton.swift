
import SwiftUI

struct TabBarButton: View {
    var image: String
    var isSelected: Bool
    
    var body: some View {
        Image(systemName: image)
            .font(.system(size: 26, weight: .semibold))
            .foregroundStyle(
                LinearGradient(
                    colors: isSelected
                    ? [Color.white, Color.white]
                    : [Color.white.opacity(0.9), Color.white.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .padding(10)
            .background(
                isSelected ? AnyView(
                    ZStack {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(LinearGradient(colors: [Color.white.opacity(0.18), Color.white.opacity(0.06)], startPoint: .top, endPoint: .bottom))
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                    }
                ) : AnyView(EmptyView())
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.25), value: isSelected)
    }
}
