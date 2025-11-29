
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
            
            TabBarButton(image: "sparkles", isSelected: selectedTab == .events)
                .onTapGesture {
                    selectedTab = .events
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
            ZStack {
                // Glass bar background aligned with SystemBackground colors
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.45),
                                Color(red: 60/255, green: 20/255, blue: 120/255).opacity(0.45)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(LinearGradient(colors: [Color.white.opacity(0.2), .clear], startPoint: .topLeading, endPoint: .center))
                    .blendMode(.screen)
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(LinearGradient(colors: [Color.white.opacity(0.85), Color.white.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 8)
        .shadow(color: .white.opacity(0.06), radius: 4, x: -2, y: -2)
        .padding(.horizontal)
    }
}
