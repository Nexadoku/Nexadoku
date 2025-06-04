
import SwiftUI

struct PremiumPaySheet: View {
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.dismiss) var dismiss
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
            Color.black.ignoresSafeArea()
            ForEach(stars) { star in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: star.size, height: star.size)
                    .foregroundColor(Color.purple.opacity(star.opacity))
                    .rotationEffect(.degrees(star.angle))
                    .position(x: star.x, y: star.y)
            }
            VStack(spacing: 24) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.purple)
                    .shadow(radius: 18)
                    .padding(.top, 8)

                Text("Lifetime Premium")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                Text("One payment. Forever Premium access. No subscriptions. No ads.")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Text("Lifetime access:")
                            .foregroundColor(.white)
                        Spacer()
                        Text("$14.99")
                            .bold()
                            .foregroundStyle(
                                LinearGradient(colors: [.white, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .font(.system(size: 20))
                    }
                }
                .font(.system(size: 18))
                .padding()
                .background(RoundedRectangle(cornerRadius: 18).fill(Color.purple.opacity(0.18)))
                .padding(.horizontal, 16)

                Button(action: {
                    Task {
                        await storeManager.purchasePremium()
                        if storeManager.isPurchased {
                            dismiss()
                        }
                    }
                }) {
                    Text(storeManager.isPurchased ? "Purchased" : "Buy Now")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(storeManager.isPurchased ? .purple : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(storeManager.isPurchased ? .gray : .purple)
                        .cornerRadius(18)
                }
                .padding(.horizontal, 40)
                .disabled(storeManager.isPurchased)
            }
            .padding()
            .presentationDetents([.medium, .large])
        }
    }
}

