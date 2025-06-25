
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    
    var body: some View {
        HStack {
            Spacer()
            TabBarButton(image: "house.fill", isSelected: selectedTab == .menu)
                .onTapGesture {
                    selectedTab = .menu
                    VibrationManager.shared.lightImpact()
                }
            Spacer()
            TabBarButton(image: "person.crop.circle.fill", isSelected: selectedTab == .account)
                .onTapGesture {
                    selectedTab = .account
                    VibrationManager.shared.lightImpact()
                }
            Spacer()
        }
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: [Color.purple.opacity(0.5), Color.purple.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .purple.opacity(0.3), radius: 20, y: -5)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 12)
    }
}
