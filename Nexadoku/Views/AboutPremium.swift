
import SwiftUI

struct AboutPremium: View {
    @StateObject private var storeManager = StoreManager()
    @State private var showRestoreAlert = false
    @State private var showRestoreFailedAlert = false
    @Environment(\.dismiss) var dismiss

    let currentPremiumFeatures: [PremiumFeature] = [
        .init(title: "No Ads", description: "Enjoy a clean game with zero ads — no banners, no popups, just pure focus."),
        .init(title: "Special Rewards", description: "Earn exclusive trophies and rewards only available to Premium users."),
        .init(title: "Legend Level", description: "Get access to the Epic difficulty mode, available only with Premium."),
        .init(title: "Smart Highlight Lines", description: "Enable Highlight Lines to automatically show all matching lines on the board.")
    ]

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
                    // Header
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(LinearGradient(colors: [.purple, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .font(.system(size: 24, weight: .heavy))
                                .padding(.leading)
                            
                            Text("Premium")
                                .font(.system(size: 40, weight: .heavy))
                                .foregroundStyle(LinearGradient(colors: [.purple, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                        }
                        Spacer()
                        Button("Restore") {
                            Task {
                                let success = await storeManager.restorePurchases()
                                withAnimation {
                                    if success {
                                        showRestoreAlert = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            withAnimation {
                                                showRestoreAlert = false
                                            }
                                        }
                                    } else {
                                        showRestoreFailedAlert = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            withAnimation {
                                                showRestoreFailedAlert = false
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.trailing)
                    }

                    // Logo
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .cornerRadius(30)
                        .shadow(color: .purple, radius: 10)

                    // Payment block
                    VStack(spacing: 12) {
                        Text("LIFETIME PREMIUM")
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)

                        Text("One-time payment. No ads. All features. Forever.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        HStack {
                            Text("Access:")
                                .foregroundColor(.white)
                            Spacer()
                            Text("$14.99")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding()

                        Button(action: {
                            Task {
                                await storeManager.purchasePremium()
                            }
                        }) {
                            Text(storeManager.isPurchased ? "Purchased" : "Buy Now")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(storeManager.isPurchased ? .purple : .white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(storeManager.isPurchased ? Color.black : Color.purple)
                                .cornerRadius(18)
                        }
                        .disabled(storeManager.isPurchased)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(LinearGradient(colors: [.purple.opacity(0.35), .black.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(radius: 18)
                    )
                    .padding(.horizontal, 30)

                    // Current features
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

                    // Coming soon
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
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.top, 8)
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 120)
                }
                .padding(.top, 30)
                .padding(.bottom, 30)
            }

            // Alerts
            if showRestoreAlert {
                PremiumAlertView(
                    icon: "checkmark.seal.fill",
                    title: "Purchase Restored",
                    message: "Your premium access has been successfully restored.",
                    color: .green
                )
            }
            if showRestoreFailedAlert {
                PremiumAlertView(
                    icon: "xmark.octagon.fill",
                    title: "Restore Failed",
                    message: "No previous purchases were found for this account.",
                    color: .red
                )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct PremiumAlertView: View {
    let icon: String
    let title: String
    let message: String
    let color: Color

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: icon)
                .font(.system(size: 44, weight: .bold))
                .foregroundColor(color)
                .shadow(radius: 16)

            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)

            Text(message)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 26)
        .background(
            RoundedRectangle(cornerRadius: 35)
                .fill(
                    LinearGradient(colors: [.black, .purple], startPoint: .top, endPoint: .bottom)
                )
                .shadow(radius: 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(color, lineWidth: 2)
                )
        )
        .padding(.horizontal, 40)
        .shadow(radius: 30)
        .transition(.scale.combined(with: .opacity))
        .zIndex(101)
    }
}

struct PremiumPreviews: PreviewProvider {
    static var previews: some View {
        AboutPremium()
            .environmentObject(StoreManager())
            .preferredColorScheme(.dark)
    }
}
