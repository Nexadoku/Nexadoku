import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var navigator: Navigator
    @ObservedObject private var game: Game
    @ObservedObject private var gameTimer: GameTimer

    @AppStorage("timerEnabled") private var timerEnabled = true
    @AppStorage("mistakesEnabled") private var mistakesEnabled = true
    @AppStorage("isPremium") private var isPremium = true


    @State private var showGameOverAlert = false
    @State private var showQuickSettings = false
    @State private var isPaused = false
    @State private var showExitConfirmation = false
    @State private var lockedNumber: Int? = nil

    init(state: GameState) {
        let newGame = Game(state: state)
        self.game = newGame
        self.gameTimer = newGame.timer
    }

    var body: some View {
        ZStack {
            SystemBackground()
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
                Color.black.opacity(0.6)
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
            }
            
            if showQuickSettings {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .zIndex(101)
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.28)) { showQuickSettings = false }
                    }
                GameQuickSettingsSheet()
                    .frame(maxWidth: 300, maxHeight: 500)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [.purple.opacity(0.92), .black.opacity(0.98)], startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .purple.opacity(0.9), radius: 30, x: 0, y: 8)
                    )
                    .padding(.horizontal, 32)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(102)
            }
            
            if showExitConfirmation {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .zIndex(100)
                    .onTapGesture {
                        // Тап по фону закрывает алерт
                        withAnimation { showExitConfirmation = false }
                    }

                VStack(spacing: 24) {
                    // Иконка или арт — можешь любую
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.purple)
                        .shadow(color: .purple, radius: 10)
                        .padding(.top, 8)

                    Text("Exit Game?")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 10)

                    Text("Are you sure you want to exit the game?")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)

                    HStack(spacing: 18) {
                        Button(action: {
                            withAnimation { showExitConfirmation = false }
                            VibrationManager.shared.lightImpact()
                        }) {
                            Text("Cancel")
                                .font(.system(size: 20, weight: .bold))
                                .frame(width: 120, height: 48)
                                .background(.purple)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }

                        Button(action: {
                            game.saveCurrentGame()
                            navigator.pop()
                            VibrationManager.shared.lightImpact()
                        }) {
                            Text("Exit")
                                .font(.system(size: 20, weight: .bold))
                                .frame(width: 120, height: 48)
                                .background(.black)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(radius: 10)
                        }
                    }
                    .padding(.bottom, 6)
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 24)
                .background(
                    LinearGradient(
                        colors: [Color.black.opacity(0.93), Color.purple.opacity(0.96)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .shadow(color: .purple.opacity(0.6), radius: 30, x: 0, y: 8)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(LinearGradient(colors: [.purple, .purple], startPoint: .leading, endPoint: .trailing), lineWidth: 3)
                    )
                )
                .padding(.horizontal, 36)
                .frame(maxWidth: 390)
                .transition(.scale.combined(with: .opacity))
                .zIndex(101)
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
                    mistakes: game.mistakes,
                    level: game.level
                )
            } else {
                LoseScreen(
                    onExit: { navigator.pop() },
                    onRetry: { game.restart() }
                )
            }
        }
   }

    private var content: some View {
        VStack {
            HStack {
                Button {
                    showExitConfirmation = true
                    VibrationManager.shared.lightImpact()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                }

                Text("NEXADOKU")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(.white)
                    .shadow(radius: 10)

                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showQuickSettings = true
                    }
                }) {
                    Image(systemName: "switch.2")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                }

                Button(action: {
                    isPaused = true
                    game.timer.stop()
                    VibrationManager.shared.lightImpact()
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
                onEraseTap: {
                    game.eraseValue()
                    VibrationManager.shared.lightImpact()
                },
                onPencilTap: {
                    game.togglePencilMode()
                    VibrationManager.shared.lightImpact()
                },
                onHintTap: {
                    game.useHint()
                    VibrationManager.shared.lightImpact()
                },
                usedNumbers: game.usedNumbersCount,
                isPencilMode: game.pencilMode,
                remainingHints: game.remainingHints
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

        let activeViews: [AnyView] = [
            AnyView(levelView),
            mistakesEnabled ? AnyView(mistakesView) : nil,
            timerEnabled ? AnyView(timerView) : nil
        ].compactMap { $0 }

        return HStack(spacing: UIDevice.current.userInterfaceIdiom == .pad ? 60 : 20) {
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
            .environmentObject(UnlockSheetManager())
    }
}
