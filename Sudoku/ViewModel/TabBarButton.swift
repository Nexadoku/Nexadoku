
import SwiftUI

struct TabBarButton: View {
    var image: String
    var isSelected: Bool
    
    var body: some View {
        Image(systemName: image)
            .font(.system(size: 28))
           
            .foregroundStyle(
                LinearGradient(
                    colors: isSelected ? [Color.white, Color.white] : [Color.white.opacity(0.6)],
                                                                         startPoint: .topLeading,
                                                                         endPoint: .bottomTrailing))
           
            .scaleEffect(isSelected ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}
