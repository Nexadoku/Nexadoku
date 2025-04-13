
import SwiftUI

struct GameView: View {
    @ObservedObject private var game: Game
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var navigator: Navigator
    @State private var showGameOverAlert = false
    @ObservedObject private var gameTimer: GameTimer
    @State private var isPaused = false
    @State private var showExitConrirmation = false
    
    init(level: DifficultyLevel) {
        let newGame = Game(level: level)
        _game = ObservedObject(wrappedValue: newGame)
        _gameTimer = ObservedObject(initialValue: newGame.timer)
    }
    
    var body: some View {
        ZStack {
            LuxuriousDarkBackgroundView()
                .blur(radius: isPaused ? 10 : 0)
            
            VStack(spacing: .zero) {
                content
            }
            
            .navigationBarBackButtonHidden(true)
            .blur(radius: isPaused ? 10 : 0)
            if isPaused {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                PauseOverlay(
                    level: game.level,
                    mistakes: game.mistakes,
                    pausedTime: game.timer.elapsedTime,
                    onResume: {
                        isPaused = false
                        game.timer.start()
                    },
                    onRestart: {
                        isPaused = false
                        game.restartCurrentGameState()
                    }
                )
                .transition(.opacity)
            }
        }
        .fullScreenCover(isPresented: $game.gameOver) {
            if game.isWon {
                WinScreen(
                    onExit: { navigator.pop() },
                    timeElapsed: game.finalTime,
                    mistakes: game.mistakes
                )
            } else {
                LoseScreen(
                    onExit: { navigator.pop() },
                    onRetry: { game.restart() }
                )
            }
        }
        .overlay(
            Group {
                if showExitConrirmation {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .zIndex(1)
                    
                    VStack(spacing: 25) {
                        Text("Are you sure you want to exit the game?")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()

                        HStack(spacing: 20) {
                            Button(action: {
                                withAnimation {
                                    showExitConrirmation = false
                                }
                            }) {
                                Text("Cancel")
                                    .font(.title3.bold())
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 14)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Capsule())
                                    .shadow(radius: 5)
                            }
                            
                            
                            Button(action: {
                                navigator.pop()
                            }) {
                                Text("Exit")
                                    .font(.title3.bold())
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 14)
                                    .background(.red)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding()
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: .purple, radius: 10)
                    .shadow(color: .indigo, radius: 10)
                    .padding(.horizontal, 30)
                    .transition(.scale)
                    .zIndex(2)
                }
            }
        )
    }
    
    private var content: some View {
        VStack {
            HStack {
                Button {
                    showExitConrirmation = true
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                }
                
                Text("SUDOKU")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                Spacer()
                
                Button(action: {
                    isPaused = true
                    game.timer.stop()
                }) {
                    Image(systemName: "pause.circle.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                }
            }
            .padding(.horizontal)
            infoPanel
            GridView(game: game)
            ButtonsView(
                onNumberTap: { game.updateValue($0) },
                onEraseTap: { game.eraseValue() },
                onPencilTap: { game.togglePencilMode() },
                onHintTap: { game.useHint() },
                usedNumbers:  game.usedNumbersCount,
                isPencilMode: game.pencilMode
            )
            .padding()
        }
    }
    
    private var infoPanel: some View {
        HStack {
            Text(game.level.rawValue)
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(.white)
            Spacer()
            Text("Mistakes: \(game.mistakes)/3")
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(.white)
            Spacer()
            HStack {
                Image(systemName: "hourglass")
                Text("\(timeFormatted(game.timer.elapsedTime))")
            }
            .font(.system(size: 18, weight: .heavy))
            .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(
            LinearGradient(colors: [.purple.opacity(0.5), .indigo.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .indigo, radius: 5)
        .shadow(color: .purple, radius: 5)
        .padding()
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct GameViewPreviews: PreviewProvider {
    static var previews: some View {
        GameView(level: .master)
            .preferredColorScheme(.dark)
            .environmentObject(Navigator())
    }
}
