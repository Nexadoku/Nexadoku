
import SwiftUI

struct AboutPremium: View {
    @State private var showPaySheet = false
    @Environment(\.dismiss) var dismiss

    // Основные, уже готовые фичи
    let currentPremiumFeatures: [PremiumFeature] = [
        .init(title: "No Ads", description: "Enjoy a clean game with zero ads — no banners, no popups, just pure focus."),
        .init(title: "Special Rewards", description: "Earn exclusive trophies and rewards only available to Premium users."),
        .init(title: "Epic Level", description: "Get access to the Epic difficulty mode, available only with Premium."),
        .init(title: "Smart Highlights", description: "Enable Highlights to automatically show all matching numbers on the board.")
    ]

    // "Скоро будут" — можешь сюда добавить больше, если хочешь
    let upcomingPremiumFeatures: [PremiumFeature] = [
        .init(title: "Exclusive Themes", description: "Get access to unique color themes and visual styles."),
        .init(title: "Custom Board Animations", description: "Choose special board and cell animation effects."),
        .init(title: "Personalized App Icons", description: "Select from a variety of Premium app icons to personalize your experience.")
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            PremiumBackground()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(
                                    LinearGradient(colors: [.purple, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .font(.system(size: 24, weight: .heavy))
                                .padding(.leading)
                            
                        }
                        Text("About Premium")
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundStyle(
                                LinearGradient(colors: [.purple, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                          Spacer()
                    }

                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .cornerRadius(30)
                        .shadow(color: .purple, radius: 10, x: 10, y: -10)
                        .shadow(color: .indigo, radius: 10, x: -10, y: 10)

                    // Блок текущих фичей
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Premium Features")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.bottom, 6)
                        ForEach(currentPremiumFeatures) { feature in
                            FeatureRow(feature: feature)
                        }
                    }
                    .padding(.horizontal)

                    // Блок "скоро"
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Coming Soon in Premium")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.purple)
                            .padding(.top, 20)
                            .padding(.bottom, 6)
                        ForEach(upcomingPremiumFeatures) { feature in
                            FeatureRow(feature: feature, icon: "sparkles")
                        }
                        Text("We’re working on these new features for Premium users. Stay tuned!")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.top, 8)
                            .padding(.leading, 4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 120)
                }
                .padding(.top, 30)
                .padding(.bottom, 30)
            }
            
            VStack {
                Button(action: { showPaySheet = true }) {
                    Text("Activate Premium")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(colors: [.purple, .indigo], startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(24)
                        .shadow(color: .purple.opacity(0.6), radius: 10, x: 0, y: 8)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 38)
            }
            .ignoresSafeArea(.keyboard)
            .sheet(isPresented: $showPaySheet) {
                PremiumPaySheet()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct FeatureRow: View {
    let feature: PremiumFeature
    var icon: String = "star.fill"

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.purple)
                    .shadow(color: .purple, radius: 8)
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

struct PremiumFeature: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

struct PremiumPaySheet: View {
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

                Button(action: { /* Purchase action */ }) {
                    Text("Buy Now")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.purple)
                        .cornerRadius(18)
                }
                .padding(.horizontal, 40)
            }
            .padding()
            .presentationDetents([.medium, .large])
        }
    }
}

struct PremiumPreviews: PreviewProvider {
    static var previews: some View {
        AboutPremium()
    }
}
