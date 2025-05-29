
import SwiftUI

struct RewardsUnlockSheet: View {
    let trophy: Trophy
    let onClose: () -> Void
    
    @State private var animateSpin = false
    @State private var animateGlow = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                Image(trophy.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .rotation3DEffect(.degrees(animateSpin ? 720 : 0), axis: (x: 0, y: 1, z: 0))
                    .shadow(color: .white, radius: 30, x: 0, y: 0)
                    .shadow(color: .purple, radius: 60, x: 0, y: 0)
                    .animation(.easeOut(duration: 1.1), value: animateSpin)
            }
            .onAppear {
                animateSpin = true
                animateGlow = true
            }
            
            Text("New Trophy Unlocked!")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                .shadow(radius: 12)
            
            Text("You got \(trophy.type.rawValue.capitalized) trophy\n for \(trophy.requiredWins) wins in level \(trophy.level.rawValue.capitalized)!")
                .multilineTextAlignment(.center)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white.opacity(0.95))
                .padding(.horizontal)
            
            Button(action: onClose) {
                Text("Continue")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 60)
            .padding(.top, 8)
            Spacer()
        }
        .padding()
        .background(
            BlurView(style: .systemThinMaterialDark)
                .ignoresSafeArea()
        )
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

struct RewardsUnlockPreviews: PreviewProvider {
    static var previews: some View {
        RewardsUnlockSheet(trophy: Trophy(level: .epic, type: .gold, requiredWins: 60, currentWins: 60), onClose: {}
        )
        .background(Color.black.ignoresSafeArea())
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
