
import SwiftUI

struct TrophyUnlockBanner: View {
    let trophy: Trophy
    let onTap: () -> Void
    
    @State private var show = false
    
    var body: some View {
        VStack {
            if show {
                HStack(spacing: 16) {
                    Image(trophy.imageName)
                        .resizable()
                        .frame(width: 44, height: 44)
                        .shadow(color: .white, radius: 6)
                        .shadow(color: .purple, radius: 12)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Trophy Unlocked!")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .bold))
                        Text("\(trophy.level.rawValue.capitalized) - \(trophy.type.rawValue.capitalized) Trophy")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(
                    BlurView(style: .systemMaterialDark)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.purple.opacity(0.35), lineWidth: 1.5)
                    )
                )
                .padding(.horizontal, 20)
                .shadow(radius: 10)
                .onTapGesture {
                    onTap()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(2000)
            }
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.48, dampingFraction: 0.85)) { show = true }
            VibrationManager.shared.lightImpact()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation { show = false }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    onTap()
                }
            }
        }
    }
}
