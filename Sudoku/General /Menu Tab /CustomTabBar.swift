
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    
    var body: some View {
        HStack {
            Spacer()
            TabBarButton(image: "house.fill", isSelected: selectedTab == .menu)
                .onTapGesture {
                    selectedTab = .menu
                }
            Spacer()
            TabBarButton(image: "person.crop.circle.fill", isSelected: selectedTab == .account)
                .onTapGesture {
                    selectedTab = .account
                }
            Spacer()
        }
        .frame(height: 70)
        .background(
            Color.black.opacity(0.2)
                .blur(radius: 10)
                .background(.black.opacity(0.6))
                .cornerRadius(30)
                .shadow(color: .indigo, radius: 10)
                .shadow(color: .purple, radius: 10)
        )
        .padding(.horizontal, 30)
        .padding(.bottom, 10)
    }
}
