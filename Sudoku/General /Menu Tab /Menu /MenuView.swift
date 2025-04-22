
import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var savedGameManager: GameSaveManager
    
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
                    if let game = savedGameManager.game {
                        saveButton(title: "Continue") {
                            navigator.push(.menu(.game(.saved(game: game))))
                        }
                    }
                    
                    neonButton(title: "Play Sudoku", icon: "gamecontroller.fill") {
                        navigator.push(.menu(.levelSelection))
                    }
                    
                    neonButton(title: "Trials", icon: "brain.head.profile.fill") {
                        navigator.push(.menu(.events))
                    }
                }
                Spacer()
            }
            .padding(.bottom)
        }
    }
    
    func saveButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.title.bold())
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: 500, maxHeight: 60)
            .background(.green)
            .cornerRadius(25)
            .shadow(color: .green, radius: 20)
        }
        .padding(.horizontal)
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
