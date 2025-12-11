
import SwiftUI

struct GlassListBackground: View {
    var cornerRadius: CGFloat = 28
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.45), radius: 18, x: 0, y: 10)
            .shadow(color: Color.white.opacity(0.06), radius: 6, x: -2, y: -2)
    }
}
