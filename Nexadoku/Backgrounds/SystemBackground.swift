
import SwiftUI

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct SystemBackground: View {
    var body: some View {
        ZStack {
            // Base deep purple to near-black gradient
            LinearGradient(
                colors: [
                    Color(red: 15/255, green: 6/255, blue: 28/255),   // deep plum
                    Color(red: 10/255, green: 5/255, blue: 20/255)    // near black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Diagonal magenta sheen (top-left to center)
            LinearGradient(
                colors: [
                    Color(red: 168/255, green: 61/255, blue: 255/255).opacity(0.45),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .center
            )
            .blendMode(.screen)
            .ignoresSafeArea()

            // Bottom purple glow
            RadialGradient(
                colors: [
                    Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.38),
                    Color.clear
                ],
                center: .bottom,
                startRadius: 10,
                endRadius: 520
            )
            .blendMode(.screen)
            .ignoresSafeArea()

            // Soft blurred blobs for depth like the reference
            Group {
                Circle()
                    .fill(Color(red: 190/255, green: 80/255, blue: 255/255).opacity(0.25))
                    .frame(width: 320, height: 320)
                    .offset(x: -180, y: -260)
                    .blur(radius: 90)

                Circle()
                    .fill(Color(red: 95/255, green: 120/255, blue: 255/255).opacity(0.22))
                    .frame(width: 280, height: 280)
                    .offset(x: 200, y: 280)
                    .blur(radius: 100)
            }
            .allowsHitTesting(false)

            // Subtle edge vignette to focus center content
            LinearGradient(
                colors: [Color.black.opacity(0.38), Color.clear, Color.black.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottom
            )
            .blendMode(.multiply)
            .ignoresSafeArea()
        }
    }
}

struct SystemDarkBackgroundPreviews: PreviewProvider {
    static var previews: some View {
        SystemBackground()
    }
}

                                                                                                 
