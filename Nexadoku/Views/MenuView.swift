
import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var savedGameManager: GameSaveManager
    
    @Environment(\.sheetIsVisible) private var sheetVisibleSetter
    
    @ObservedObject var progress = ProgressManager.shared
    
    @State private var animate = false
    @State private var unlockedTrophyBanner: Trophy? = nil
    @State private var alertAppear = false
    @State private var glow = false
    @State private var showContinueSheet = false {
        didSet {
            onSheetChange(showContinueSheet)
        }
    }

    @AppStorage("claimedTrophyIDs") private var claimedTrophyIDs: String = ""
    
    var onSheetChange: (Bool) -> Void = { _ in}

    private var claimableTrophiesCount: Int {
        let claimedIDs = Set(claimedTrophyIDs.split(separator: ",").map(String.init))
        return DifficultyLevel.allCases.flatMap { level in
            let wins = progress.winsCount(for: level)
            return [
                Trophy(level: level, type: .bronze, requiredWins: 10, currentWins: wins),
                Trophy(level: level, type: .silver, requiredWins: 20, currentWins: wins),
                Trophy(level: level, type: .gold, requiredWins: 30, currentWins: wins)
            ]
        }
        .filter { $0.isUnlocked && !claimedIDs.contains($0.uniqueID) }
        .count
    }
    
    

    var body: some View {
        ZStack {
            SystemBackground()
            ScrollView {
                VStack(spacing: 30) {
                    HStack(spacing: 0) {
                        Spacer()
                        Button(action: {
                            navigator.push(.menu(.premium))
                            VibrationManager.shared.lightImpact()
                        }) {
                            PremiumCrownIcon()
                                .frame(width: 42, height: 42)
                                .padding(.trailing)
                        }
                        .padding(.top, 8)
                    }
                    
                    Image("nexadoku")
                        .resizable()
                        .frame(width: 280, height: 40)

                    Image("logo")
                        .resizable()
                        .frame(width: 140, height: 140)
                        .cornerRadius(30)
                        .shadow(color: Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.7), radius: 18, x: 0, y: 8)
                        .shadow(color: Color.white.opacity(0.08), radius: 6, x: -2, y: -2)
                        .padding(.bottom, 50)

                    VStack(spacing: 20) {
                        if let game = savedGameManager.game {
                            glassMenuButton(title: "Continue Game", iconImageName: "player_continue_game") {
                                withAnimation(.spring(response: 0.38, dampingFraction: 0.75)) {
                                    showContinueSheet = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.13) {
                                    alertAppear = true
                                }
                                VibrationManager.shared.lightImpact()
                            }
                        }

                        glassMenuButton(title: "New Game", iconImageName: "gamecontroller_new_game") {
                            navigator.push(.menu(.levelSelection))
                            VibrationManager.shared.lightImpact()
                        }
                        
                        ZStack(alignment: .topTrailing) {
                            glassMenuButton(title: "Rewards", iconImageName: "star_rewards") {
                                navigator.push(.menu(.rewards))
                            }
                            if claimableTrophiesCount > 0 {
                                BadgeView(count: claimableTrophiesCount)
                                    .offset(x: -23, y: -12)
                            }
                        }
                    }
                }
                .padding(.bottom)
            }
            
            .opacity(showContinueSheet ? 0.0 : 1)
            .scaleEffect(showContinueSheet ? 0.96 : 1)
            .blur(radius: showContinueSheet ? 1 : 0)
            .animation(.easeInOut(duration: 0.25), value: showContinueSheet)
            .allowsHitTesting(!showContinueSheet)
    
            .onAppear {
                withAnimation(.easeInOut(duration: 1.45).repeatForever(autoreverses: true)) {
                    glow = true
                }
                if unlockedTrophyBanner == nil, let trophy = firstJustUnlockedTrophy() {
                    unlockedTrophyBanner = trophy
                }
            }

            if let bannerTrophy = unlockedTrophyBanner {
                TrophyUnlockBanner(trophy: bannerTrophy) {
                    progress.markTrophyAsShown(bannerTrophy)
                    withAnimation { unlockedTrophyBanner = nil }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(2000)
            }

            if showContinueSheet {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .zIndex(10)
                    .onTapGesture {
                        withAnimation { showContinueSheet = false }
                    }

                ContinueGameSheet(
                    onContinue: {
                        if let game = savedGameManager.game {
                            navigator.push(.menu(.game(.saved(game: game))))
                        }
                    withAnimation { showContinueSheet = false }
                    },
                    onCancel: {
                        withAnimation { showContinueSheet = false }
                    }
                )
                .zIndex(11)
                .transition(.scale.combined(with: .opacity))
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
                Trophy(level: level, type: .bronze, requiredWins: 10, currentWins: wins),
                Trophy(level: level, type: .silver, requiredWins: 20, currentWins: wins),
                Trophy(level: level, type: .gold, requiredWins: 30, currentWins: wins)
            ]
        }
        for trophy in trophies where trophy.isUnlocked && !progress.isTrophyShown(trophy) {
            return trophy
        }
        return nil
    }
    
    /// Premium glass effect background with enhanced depth and reflections - Purple only
    struct GlossyPurpleBackground: View {
        var cornerRadius: CGFloat = 25

        var body: some View {
            ZStack {
                // Base: Rich purple gradient with depth
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.95),
                                Color.purple.opacity(0.75),
                                Color.purple.opacity(0.45)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Secondary gradient for more depth - darker purple
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.purple.opacity(0.4),
                                Color.clear,
                                Color.purple.opacity(0.2)
                            ],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: 200
                        )
                    )

                // Main glass highlight - light purple reflection
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.6),
                                Color.purple.opacity(0.2),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .center
                        )
                    )
                    .blur(radius: 1.5)
                    .blendMode(.screen)

                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.3),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
                    .blur(radius: 3)
                    .blendMode(.overlay)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.purple.opacity(0.8),
                                Color.purple.opacity(0.3),
                                .clear
                            ],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .offset(x: -25, y: -25)
                    .blur(radius: 1)
                    .blendMode(.screen)

                // Inner shadow for depth - dark purple
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.purple.opacity(0.4), lineWidth: 8)
                    .blur(radius: 8)
                    .offset(x: 3, y: 6)
                    .mask(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(
                                LinearGradient(
                                    colors: [.clear, .black, .black],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )

                // Subtle inner glow
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.purple.opacity(0.3), lineWidth: 2)
                    .blur(radius: 4)
                    .offset(x: -1, y: -1)

                // Premium glass border - light purple
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.7),
                                Color.purple.opacity(0.4),
                                Color.purple.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
                
                // Subtle inner border for extra definition
                RoundedRectangle(cornerRadius: cornerRadius - 1)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.2),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
        }
    }

    func glassMenuButton(
        title: String,
        iconSystem: String? = nil,
        iconImageName: String? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                
                // Custom PNG icon
                if let iconImageName = iconImageName {
                    Image(iconImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .shadow(color: .white.opacity(0.15), radius: 4)
                }
                
                // SF Symbol icon
                else if let iconSystem = iconSystem {
                    Image(systemName: iconSystem)
                        .font(.title2.weight(.semibold))
                }
                
                // TEXT INSTEAD OF IMAGE
                Text(title)
                    .font(.title2.bold())
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: 500, maxHeight: 60)
            .background(GlassProfileBackground(cornerRadius: 25))
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .shadow(color: Color.black.opacity(0.35), radius: 14, x: 0, y: 10)
            .shadow(color: Color.white.opacity(0.06), radius: 6, x: -2, y: -2)
        }
        .padding(.horizontal)
    }

    struct GlassMenuBackground: View {
        var cornerRadius: CGFloat = 25
        var body: some View {
            ZStack {
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.55),
                                Color(red: 60/255, green: 20/255, blue: 120/255).opacity(0.55)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(LinearGradient(colors: [Color.white.opacity(0.22), .clear], startPoint: .topLeading, endPoint: .center))
                    .blendMode(.screen)
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(colors: [Color.white.opacity(0.8), Color.white.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1
                    )
            }
        }
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
