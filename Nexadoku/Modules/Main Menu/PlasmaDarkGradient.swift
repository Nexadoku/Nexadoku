
import SwiftUI

struct GlossyGelBackground: View {
    var cornerRadius: CGFloat = 22
    var base: Color = Color(hue: 0.76, saturation: 0.75, brightness: 0.95)
    
    @State private var sheen = false
    var animateSheen: Bool = true
    var pressed: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    LinearGradient(colors: [
                        base.opacity(0.95),
                        base.opacity(0.75),
                        base.opacity(0.98)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    RadialGradient(gradient: Gradient(colors: [
                        Color.black.opacity(0.45), .clear
                    ]), center: .bottomTrailing, startRadius: 0, endRadius: 260)
                )
                .blendMode(.multiply)
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(colors: [
                        .white.opacity(0.65), .white.opacity(0.15), .clear
                    ], startPoint: .topLeading, endPoint: .center)
                )
                .blur(radius: 4)
                .opacity(0.9)
            
            Circle()
                .fill(
                    RadialGradient(gradient: Gradient(colors: [
                        .white.opacity(0.95), .white.opacity(0.0)
                    ]), center: .topLeading, startRadius: 0, endRadius: 120)
                )
                .offset(x: -18, y: -18)
                .blur(radius: 1.5)
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    Color.black.opacity(0.55), lineWidth: 6
                )
                .blur(radius: 6)
                .offset(x: 2, y: 4)
                .mask(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .top))
                )
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    LinearGradient(colors: [
                        .white.opacity(0.75), .white.opacity(0.15)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 1.2
                )
        }
    }
}
