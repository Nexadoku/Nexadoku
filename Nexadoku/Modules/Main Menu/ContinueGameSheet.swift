
import Foundation
import SwiftUI
struct ContinueGameSheet: View {
    var onContinue: () -> Void
    var onCancel: () -> Void
    
    @State private var appear = false
    @State private var contentAppear = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.42),
                            Color(red: 60/255, green: 20/255, blue: 120/255).opacity(0.42)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.35), radius: 18, x: 0, y: 10)
            
            VStack(spacing: 30) {
                
                Image("gamecontroller_new_game")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .shadow(color: .white.opacity(0.5), radius: 10)
                    .opacity(contentAppear ? 1 : 0)
                    .scaleEffect(contentAppear ? 1 : 0.9)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.05), value: contentAppear)
                
                Text("CONTINUE GAME?")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .opacity(contentAppear ? 1 : 0)
                    .offset(y: contentAppear ? 0 : 16)
                    .animation(.easeOut(duration: 0.3).delay(0.15), value: contentAppear)
                
                Text("Do you want to continue your saved game?")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                    .opacity(contentAppear ? 1 : 0)
                    .offset(y: contentAppear ? 0 : 16)
                    .animation(.easeOut(duration: 0.3).delay(0.25), value: contentAppear)
                
                Text("You left a puzzle unfinished. You can continue exactly where you stoppe your progress and time will stay unchanged.")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .opacity(contentAppear ? 1 : 0)
                    .offset(y: contentAppear ? 0 : 20)
                    .animation(.easeOut(duration: 0.3).delay(0.35), value: contentAppear)
                
                HStack(spacing: 18) {
                    Button(action: onCancel) {
                        Text("Cancel")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.black.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    Button(action: onContinue) {
                        Text("Continue")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(red: 140/255, green: 60/255, blue: 255/255))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(radius: 12)
                    }
                }
                
                .padding(.horizontal, 8)
                .opacity(contentAppear ? 1 : 0)
                .offset(y: contentAppear ? 0 : 25)
                .animation(.easeOut(duration: 0.3).delay(0.45), value: contentAppear)
                
            }
            
            .padding(28)
            
        }
        .frame(maxWidth: 380)
        .scaleEffect(appear ? 1 : 0.9)
        .opacity(appear ? 1 : 0)
        .animation(.easeInOut(duration: 0.28), value: appear)
        .onAppear {
            appear = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                contentAppear = true
            }
        }
    }
}
