
import SwiftUI

struct AboutPremium: View {
    @StateObject private var storeManager = StoreManager()
    @State private var showPaySheet = false
    @Environment(\.dismiss) var dismiss

    // Основные, уже готовые фичи
    let currentPremiumFeatures: [PremiumFeature] = [
        .init(title: "No Ads", description: "Enjoy a clean game with zero ads — no banners, no popups, just pure focus."),
        .init(title: "Special Rewards", description: "Earn exclusive trophies and rewards only available to Premium users."),
        .init(title: "Legend Level", description: "Get access to the Epic difficulty mode, available only with Premium."),
        .init(title: "Smart Highlight Lines", description: "Enable Highlight Lines to automatically show all matching lines on the board.")
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
                            
                            
                            Text("About Premium")
                                .font(.system(size: 40, weight: .heavy))
                                .foregroundStyle(
                                    LinearGradient(colors: [.purple, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                        }
                          Spacer()
                    }

                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .cornerRadius(30)
                        .shadow(color: .purple, radius: 10)
         

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
                Button(action: {
                    if !storeManager.isPurchased {
                        showPaySheet = true
                    }
                }) {
                    HStack(spacing: 8) {
                        if storeManager.isPurchased {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                                .transition(.scale)
                        }
                        Text(storeManager.isPurchased ? "Purchased" : "Get Premium")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        storeManager.isPurchased
                        ? LinearGradient(colors: [.gray.opacity(0.5), .gray.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(colors: [.purple], startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(24)
                    .shadow(color: storeManager.isPurchased ? .gray : .purple.opacity(0.6), radius: 10, x: 0, y: 8)
                    .overlay(
                        storeManager.isPurchased ?
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.green, lineWidth: 2)
                            : nil
                    )
                    .animation(.easeInOut(duration: 0.3), value: storeManager.isPurchased)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 38)
                .disabled(storeManager.isPurchased)
            }
            .ignoresSafeArea(.keyboard)
            .sheet(isPresented: $showPaySheet) {
                PremiumPaySheet()
                    .presentationDetents([.medium])
                    .environmentObject(storeManager)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct PremiumPreviews: PreviewProvider {
    static var previews: some View {
        AboutPremium()
    }
}
