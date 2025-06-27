
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
        .padding()
        .background(
           RoundedRectangle(cornerRadius: 35)
            .stroke(.purple, lineWidth: 1)
            .background(.purple)
            .cornerRadius(35)
        )
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}
