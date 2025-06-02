import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var savedGameManager: GameSaveManager
    
    @ObservedObject var progress = ProgressManager.shared
    @State private var animate = false
    @State private var unlockedTrophyBanner: Trophy? = nil
    @State private var showContinueAlert = false
    @State private var alertAppear = false
    @State private var glow = false

    var body: some View {
        ZStack {
            SystemDarkBackground()
            ScrollView {
                VStack(spacing: 30) {
                    HStack(spacing: 0) {
                        Spacer()
                        Button(action: {
                            navigator.push(.menu(.premium))
                            VibrationManager.shared.lightImpact()
                        }) {
                            Image("premium")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .shadow(color: .purple.opacity(glow ? 0.6 : 0.13), radius: glow ? 28 : 12, x: 0, y: 0)
                                .shadow(color: .white.opacity(glow ? 0.16 : 0.02), radius: glow ? 12 : 2, x: 0, y: 0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(
                                            LinearGradient(colors: [.purple, .white.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: glow ? 3.5 : 2
                                        )
                                        .blur(radius: glow ? 2.5 : 0)
                                        .opacity(glow ? 0.86 : 0.18)
                                )
                                .scaleEffect(glow ? 1.08 : 1.0)
                                .animation(.easeInOut(duration: 1.45).repeatForever(autoreverses: true), value: glow)
                                .padding(.trailing)
                        }
                        .padding(.top, 8)
                    }
                        Text("NEXADOKU")
                            .font(.system(size: 50, weight: .heavy))
                            .foregroundColor(.white)
                        

                    Image("logo")
                        .resizable()
                        .frame(width: 140, height: 140)
                        .cornerRadius(30)
                        .shadow(color: .purple, radius: 15)
                        .padding(.bottom, 50)
                    

                    VStack(spacing: 20) {
                        if let game = savedGameManager.game {
                            saveButton(title: "Continue Game", icon: "play.fill") {
                                withAnimation(.spring(response: 0.48, dampingFraction: 0.72)) {
                                    showContinueAlert = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.13) {
                                    alertAppear = true
                                }
                                VibrationManager.shared.lightImpact()
                            }
                        }

                        neonButton(title: "New Game", icon: "gamecontroller.fill") {
                            navigator.push(.menu(.levelSelection))
                            VibrationManager.shared.lightImpact()
                        }

//                        neonButton(title: "Trials", icon: "brain.head.profile.fill") {
//                            navigator.push(.menu(.events))
//                            VibrationManager.shared.lightImpact()
//                        }

                        neonButton(title: "Rewards", icon: "star.fill") {
                            navigator.push(.menu(.rewards))
                        }
                    }
                }
                .padding(.bottom)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.45).repeatForever(autoreverses: true)) {
                    glow = true
                }
                if unlockedTrophyBanner == nil, let trophy = firstJustUnlockedTrophy() {
                    unlockedTrophyBanner = trophy
                }
            }

            // Sheet награды (если нужно)
            if let bannerTrophy = unlockedTrophyBanner {
                TrophyUnlockBanner(trophy: bannerTrophy) {
                    progress.markTrophyAsShown(bannerTrophy)
                    withAnimation { unlockedTrophyBanner = nil }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(2000)
            }

            // Кастомный alert в центре
            if showContinueAlert {
                Color.black.opacity(alertAppear ? 0.45 : 0)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .blur(radius: alertAppear ? 3 : 0)
                    .animation(.easeInOut(duration: 0.23), value: alertAppear)
                    .onTapGesture { closeContinueAlert() }
                    .zIndex(1010)

                ContinueAlert(
                    appear: alertAppear,
                    onContinue: {
                        if let game = savedGameManager.game {
                            navigator.push(.menu(.game(.saved(game: game))))
                        }
                        closeContinueAlert()
                    },
                    onCancel: {
                        closeContinueAlert()
                    }
                )
                .zIndex(1011)
                .transition(.identity)
                .allowsHitTesting(true)
            }
        }
    }
    
    func closeContinueAlert() {
        withAnimation(.easeInOut(duration: 0.13)) {
            alertAppear = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.13) {
            withAnimation(.easeInOut(duration: 0.18)) {
                showContinueAlert = false
            }
        }
    }
    
    func closeSheet() {
        if let trophy = unlockedTrophyBanner {
            progress.markTrophyAsShown(trophy)
        }
        withAnimation {
            unlockedTrophyBanner = nil
        }
    }
    
    private func firstJustUnlockedTrophy() -> Trophy? {
        let trophies = DifficultyLevel.allCases.flatMap { level in
            let wins = progress.winsCount(for: level)
            return [
                Trophy(level: level, type: .bronze, requiredWins: 18, currentWins: wins),
                Trophy(level: level, type: .silver, requiredWins: 30, currentWins: wins),
                Trophy(level: level, type: .gold, requiredWins: 45, currentWins: wins)
            ]
        }
        for trophy in trophies where trophy.isUnlocked && !progress.isTrophyShown(trophy) {
            return trophy
        }
        return nil
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

// MARK: - Кастомный центрированный алерт

struct ContinueAlert: View {
    var appear: Bool
    var onContinue: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 44, weight: .bold))
                .foregroundColor(.purple)
                .shadow(radius: 16)
                .padding(.top, 6)

            Text("Continue Game?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 2)
            Text("Do you want to continue your saved game?")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.86))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)

            HStack(spacing: 18) {
                Button(action: onCancel) {
                    Text("Cancel")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.ultraThinMaterial)
                        .cornerRadius(14)
                }
                Button(action: onContinue) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.purple)
                        .cornerRadius(14)
                }
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 35)
                .fill(
                    LinearGradient(colors: [.black, .purple], startPoint: .bottomTrailing, endPoint: .topLeading)
                )
                .shadow(radius: 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(Color.purple, lineWidth: 2)
                )
        )
        .padding(.horizontal, 40)
        .shadow(radius: 32)
        .opacity(appear ? 1 : 0)
        .scaleEffect(appear ? 1 : 0.84)
        .animation(.interpolatingSpring(stiffness: 330, damping: 26), value: appear)
    }
}

struct MenuViewPreviews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .preferredColorScheme(.dark)
            .environmentObject(Navigator())
            .environmentObject(GameSaveManager())
    }
}
