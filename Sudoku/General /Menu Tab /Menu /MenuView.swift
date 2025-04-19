
import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var navigator: Navigator
    
    var body: some View {
        ZStack {
            SystemDarkBackground()
            VStack(spacing: 30) {
                Spacer()
                Text("SUDOKU")
                    .font(.system(size: 50, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                VStack(spacing: 20) {
                    neonButton(title: "Play Sudoku", icon: "gamecontroller.fill") {
                        navigator.push(.menu(.levelSelection))
                        SoundManager.shared.playSound(named: "back.click")
                    }
                    
                    neonButton(title: "Trials", icon: "brain.head.profile.fill") {
                        navigator.push(.menu(.events))
                        SoundManager.shared.playSound(named: "back.click")
                    }
                }
              Spacer()
            }
            .padding(.bottom)
        }
    }
    
    func neonButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack {
                    Image(systemName: icon)
                        .font(.title2)
                    Text(title)
                        .font(.title2.bold())
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: 500, maxHeight: 60)
                .background(.purple)
                .cornerRadius(25)
                .shadow(radius: 10)
            }
            .padding(.horizontal)
        }
}

struct MenuViewPreviews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .preferredColorScheme(.dark)
    }
}
