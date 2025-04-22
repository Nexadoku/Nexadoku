
import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var navigator: Navigator
    @ObservedObject private var game: Game
    @ObservedObject private var gameTimer: GameTimer
    
    @AppStorage("timerEnabled") private var timerEnabled = true
    @AppStorage("mistakesEnabled") private var mistakesEnabled = true
    
    @State private var showGameOverAlert = false
    @State private var isPaused = false
    @State private var showExitConrirmation = false
    @State private var lockedNumber: Int? = nil
    
    init(state: GameState) {
        let newGame  = Game(state: state)
        self.game = newGame
        self.gameTimer = newGame.timer
    }
    
    var body: some View {
        ZStack {
            SystemDarkBackground()
                .blur(radius: isPaused ? 10 : 0)
            
            VStack(spacing: .zero) {
                if game.isLoading || game.grid.isEmpty {
                    ProgressView()
                } else {
                    content
                }
            }
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
                        game.restart()
                    }
                )
                .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await game.loadGame()
            
            if !timerEnabled {
                game.timer.stop()
            } else {
                game.timer.start()
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
        .overlay(warning)
    }
    
    private var warning: some View {
        Group {
            if showExitConrirmation {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .zIndex(1)
                
                VStack(spacing: 25) {
                    Text("exit_confirmation")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()

                    HStack(spacing: 20) {
                        AppButton(text: "Cancel") {
                            withAnimation {
                                showExitConrirmation = false
                            }
                        }
                        .appButtonVariation(.primary)
                        
                        AppButton(text: "Exit") {
                            game.saveCurrentGame()
                            navigator.pop()
                        }
                        .appButtonVariation(.destructive)
                    }
                }
                .padding()
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .padding(.horizontal, 30)
                .transition(.scale)
                .zIndex(2)
            }
        }
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
        let levelView = Text(game.level.rawValue)
            .font(.system(size: 18, weight: .heavy))
            .foregroundColor(.white)
        
        let mistakesView = Text("Mistakes: \(game.mistakes)/3")
            .font(.system(size: 18, weight: .heavy))
            .foregroundColor(.white)
        
        let timerView = HStack {
            Image(systemName: "hourglass")
            Text("\(timeFormatted(game.timer.elapsedTime))")
        }
        .font(.system(size: 18, weight: .heavy))
        .foregroundColor(.white)

        // Собираем активные элементы
        let activeViews: [AnyView] = [
            AnyView(levelView),
            mistakesEnabled ? AnyView(mistakesView) : nil,
            timerEnabled ? AnyView(timerView) : nil
        ].compactMap { $0 }
        
        return HStack(spacing: 40) {
            ForEach(0..<activeViews.count, id: \.self) { index in
                activeViews[index]
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(.purple)
        .clipShape(RoundedRectangle(cornerRadius: 20))
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
        GameView(state: .new(level: .easy))
            .preferredColorScheme(.dark)
            .environmentObject(Navigator())
    }
}
