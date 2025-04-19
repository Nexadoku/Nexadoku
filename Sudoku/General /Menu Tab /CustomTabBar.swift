
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    
    var body: some View {
        HStack {
            Spacer()
            TabBarButton(image: "house.fill", isSelected: selectedTab == .menu)
                .onTapGesture {
                    selectedTab = .menu
                    SoundManager.shared.playSound(named: "back.click")
                    VibrationManager.shared.lightImpact()
                }
            Spacer()
            TabBarButton(image: "person.crop.circle.fill", isSelected: selectedTab == .account)
                .onTapGesture {
                    selectedTab = .account
                    SoundManager.shared.playSound(named: "back.click")
                    VibrationManager.shared.lightImpact()
                }
            Spacer()
        }
        .frame(height: 70)
        .background(
            Color.purple
                .blur(radius: 10)
                .background(.purple.opacity(0.6))
                .cornerRadius(30)
                .shadow(radius: 10)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}
