
import SwiftUI

struct AboutPremium: View {
    @StateObject private var storeManager = StoreManager()
    @State private var showRestoreAlert = false
    @State private var showRestoreFailedAlert = false
    @Environment(\.dismiss) var dismiss
    
    let currentPremiumFeatures: [PremiumFeature] = [
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
                VStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 28, weight: .heavy))
                                .foregroundColor(.white)
                            
                            Text("Get Premium")
                                .font(.system(size: 28, weight: .heavy))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        Text("Unlock all the app features by subscribing to the Premium version.")
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(.white.opacity(0.8))
                            .padding()
                    }
                    
                    VStack(alignment: .leading, spacing: 18) {
                        ForEach(currentPremiumFeatures) { feature in
                            FeatureRow(feature: feature)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                    
                    VStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 10) {
                           Text("Lifetime Access")
                                .font(.title3.weight(.heavy))
                                .foregroundColor(.white)
                        
                           Text("$14.99/one-time payment")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.white)
                            
                            Divider()
                            
                           Text("Unlock extra features.")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.22),
                                                Color(red: 60/255, green: 20/255, blue: 120/255).opacity(0.22)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.8), Color.white.opacity(0.25)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            }
                        )
                        .cornerRadius(19)
                        .shadow(radius: 19)
                        
                        Button(action: {
                            Task {
                                await storeManager.purchasePremium()
                            }
                        }) {
                            Text(storeManager.isPurchased ? "Purchased" : "Subscribe")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        Color(red: 140/255, green: 60/255, blue: 255/255).opacity(storeManager.isPurchased ? 0.12 : 0.45),
                                                        Color(red: 60/255, green: 20/255, blue: 120/255).opacity(storeManager.isPurchased ? 0.12 : 0.45)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                                    }
                                )
                                .cornerRadius(18)
                        }
                        .disabled(storeManager.isPurchased)
                    }
                    .padding(.horizontal)
                    
                    Button("Restore Subscription") {
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
                    .foregroundColor(.white)
                    .padding()
                    
     
                 
                    
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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                    VibrationManager.shared.lightImpact()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                        
                       Text("Back")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .toolbarBackground(
            LinearGradient(
                colors: [
                    Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.26),
                    Color(red: 60/255, green: 20/255, blue: 120/255).opacity(0.26)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
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
            ZStack {
                RoundedRectangle(cornerRadius: 35, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.35),
                                Color(red: 60/255, green: 20/255, blue: 120/255).opacity(0.35)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                RoundedRectangle(cornerRadius: 35, style: .continuous)
                    .stroke(color, lineWidth: 2)
            }
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
