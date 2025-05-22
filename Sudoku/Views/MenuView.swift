
import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var savedGameManager: GameSaveManager
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            SystemDarkBackground()
            ScrollView {
                VStack(spacing: 30) {
                    Text("SUDOKU")
                        .font(.system(size: 50, weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 140, height: 140)
                        .cornerRadius(30)
                        .shadow(color: .purple, radius: 10)
                        .shadow(color: .indigo, radius: 10)
                        .padding(.bottom, 50)
                    
                    VStack(spacing: 20) {
                        if let game = savedGameManager.game {
                            saveButton(title: "Continue Game", icon: "play.fill") {
                                navigator.push(.menu(.game(.saved(game: game))))
                                VibrationManager.shared.lightImpact()
                            }
                        }
                        
                        neonButton(title: "New Game", icon: "gamecontroller.fill") {
                            navigator.push(.menu(.levelSelection))
                            VibrationManager.shared.lightImpact()
                        }
                        
                        neonButton(title: "Trials", icon: "brain.head.profile.fill") {
                            navigator.push(.menu(.events))
                            VibrationManager.shared.lightImpact()
                        }
                        
                        neonButton(title: "Rewards", icon: "star.fill") {
                            navigator.push(.menu(.rewards))
                        }
                    }
                }
                .padding(.bottom)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 20)
                .animation(.easeOut(duration: 1.0).delay(0.2), value: animate)
            }
            .onAppear {
                animate = true
            }
        }
    }
    
    func saveButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
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
            .background(.black.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.purple, lineWidth: 3)
            )
            .cornerRadius(25)
            .shadow(color: .purple, radius: 20)
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
