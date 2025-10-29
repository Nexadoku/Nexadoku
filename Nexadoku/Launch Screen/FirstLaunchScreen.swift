
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
                .shadow(color: Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.7), radius: 18, x: 0, y: 8)
                .shadow(color: Color.white.opacity(0.08), radius: 6, x: -2, y: -2)
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
