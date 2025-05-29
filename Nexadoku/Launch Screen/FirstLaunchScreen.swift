
import SwiftUI

struct FirstLaunchScreen: View {
    @State private var logoScale: CGFloat = 0.1
    @State private var logoOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .cornerRadius(30)
                .shadow(color: .purple, radius: 20)
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        logoScale = 1.0
                        logoOpacity = 1.0
                }
            }
        }
    }
}

#Preview {
    FirstLaunchScreen()
}
