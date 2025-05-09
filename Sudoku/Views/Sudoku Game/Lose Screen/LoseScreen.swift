
import SwiftUI

struct LoseScreen: View {
    var onExit: () -> Void
    var onRetry: () -> Void
    
    @EnvironmentObject private var navigator: Navigator
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            AfterGameBackground()
                .ignoresSafeArea()

            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    Text("Game Over")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(colors: [.red, .pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .shadow(color: .red.opacity(0.6), radius: 10, x: 0, y: 5)
                        .scaleEffect(animate ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animate)
                    
                    Text("You made 3 mistakes and lost this game.")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }

                HStack(spacing: 20) {
                    Button(action: onRetry) {
                        Text("Retry")
                            .font(.title3.bold())
                            .padding(.horizontal, 40)
                            .padding(.vertical, 16)
                            .background(.purple)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(color: .purple, radius: 10)
                    }

                    Button(action: {
                        navigator.pop()
                    }) {
                        Text("Exit")
                            .font(.title3.bold())
                            .padding(.horizontal, 40)
                            .padding(.vertical, 16)
                            .background(.black)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(color: .black.opacity(0.6), radius: 8)
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onAppear {
            animate = true
        }
    }
}
