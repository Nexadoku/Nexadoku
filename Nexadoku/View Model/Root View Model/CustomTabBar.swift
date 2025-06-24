
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
        .frame(height: 50)
        .background(
            .thinMaterial
        )
    }
}
