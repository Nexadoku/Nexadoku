
import SwiftUI

struct AboutPremium: View {
    @StateObject private var storeManager = StoreManager()
    @State private var showPaySheet = false
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
                            
                            Text("Premium")
                                .font(.system(size: 40, weight: .heavy))
                                .foregroundStyle(
                                    LinearGradient(colors: [.purple, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                        }
                          Spacer()
                        
                        Button("Restore") {
                            Task {
                                let success = await storeManager.restorePurchases()
                                withAnimation {
                                    if success {
                                        showRestoreAlert = true // Успешный алерт
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
                                            }// Новый алерт, если покупка не была найдена
                                    }
                                }
                            }
                        }
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.trailing)
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
            
            if showRestoreAlert {
                VStack(spacing: 18) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(.green)
                        .shadow(radius: 16)
                    
                    Text("Purchase Restored")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Your premium access has been successfully restored.")
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
                                .stroke(Color.purple, lineWidth: 2)
                        )
                )
                .padding(.horizontal, 40)
                .shadow(radius: 30)
                .opacity(showRestoreAlert ? 1 : 0)
                .scaleEffect(showRestoreAlert ? 1 : 0.84)
                .animation(.interpolatingSpring(stiffness: 300, damping: 25), value: showRestoreAlert)
                .transition(.scale.combined(with: .opacity))
                .zIndex(101)
            }
            
            if showRestoreFailedAlert {
                VStack(spacing: 18) {
                    Image(systemName: "xmark.octagon.fill")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(.red)
                        .shadow(radius: 16)
                    
                    Text("Restore Failed")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("No previous purchases were found fot this account.")
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
                                .stroke(Color.purple, lineWidth: 2)
                        )
                )
                .padding(.horizontal, 40)
                .shadow(radius: 30)
                .opacity(showRestoreFailedAlert ? 1 : 0)
                .scaleEffect(showRestoreFailedAlert ? 1 : 0.84)
                .animation(.interpolatingSpring(stiffness: 300, damping: 25), value: showRestoreFailedAlert)
                .transition(.scale.combined(with: .opacity))
                .zIndex(101)
                
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
