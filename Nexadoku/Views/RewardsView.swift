
import SwiftUI

struct RewardsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var progress = ProgressManager.shared
    @State private var selectedTeb: RewardTab = .levels
    @State private var selectedTrophy: Trophy? = nil
    @State private var showPointsSheet = false
    
    @AppStorage("totalPoints") private var totalPoints: Int = 0
    @AppStorage("earnedTrophyIDs") private var earnedTrophyIDs: String = ""
    @AppStorage("claimedTrophyIDs") private var claimedTrophyIDs: String = ""

    var levelsTrophies: [Trophy] {
        DifficultyLevel.allCases
            .filter { $0 != .legend }
            .flatMap { level in
                let wins = progress.winsCount(for: level)
                return [
                    Trophy(level: level, type: .bronze, requiredWins: 10, currentWins: wins),
                    Trophy(level: level, type: .silver, requiredWins: 20, currentWins: wins),
                    Trophy(level: level, type: .gold, requiredWins: 30, currentWins: wins)
                ]
            }
    }
    
    var premiumTrophies: [PremiumTrophy] {
        [PremiumTrophy(
            id: UUID(),
            level: .legend,
            requiredWins: 5,
            currentWins: progress.winsCount(for: .legend),
            imageName: "legend_premium_trophy",
            title: "Legend Master",
            description: "Win The Legend level 5 times to unlock the ultimate trophy!"
        )]
    }
    
    private func points(for trophy: Trophy) -> Int {
        switch trophy.type {
        case .bronze: return 10
        case .silver: return 30
        case .gold: return 60
        }
    }
    
    private var claimedIDs: Set<String> {
        Set(claimedTrophyIDs.split(separator: ",").map(String.init))
    }
    
    private func claimPoints(for trophy: Trophy) {
        guard trophy.isUnlocked, !claimedIDs.contains(trophy.uniqueID) else { return }
        totalPoints += points(for: trophy)
        let newIDs = claimedIDs.union([trophy.uniqueID])
        claimedTrophyIDs = newIDs.joined(separator: ",")
        VibrationManager.shared.lightImpact()
    }
   
    private func checkAndAwardPoints() {
        var ids = Set(earnedTrophyIDs.split(separator: ",").map { String($0) })
        var newPoints = 0
        
        for trophy in levelsTrophies where trophy.isUnlocked {
            let id = trophy.uniqueID
            if !ids.contains(id) {
                newPoints += points(for: trophy)
                ids.insert(id)
            }
        }
        if newPoints > 0 {
            totalPoints += newPoints
            earnedTrophyIDs = ids.joined(separator: ",")
        }
    }
    
    var body: some View {
        ZStack {
            SystemBackground()
            ScrollView {
                VStack(spacing: 18) {
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .heavy))
                            
                            Text("REWARDS")
                                .foregroundColor(.white)
                                .font(.system(size: 30, weight: .heavy))
                        }
                        Spacer()
                        
                        Button {
                            withAnimation(.spring(response: 0.38, dampingFraction: 0.78)) {
                                showPointsSheet = true
                            }
                        } label : {
                            HStack {
                                Image("coin")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                Text("\(totalPoints)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 19, weight: .heavy))
                                    .shadow(radius: 4)
                            }
                            .padding()
                        }
                    }
                    .padding(.top, 12)
                    
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                    
                    ForEach(levelsTrophies) { trophy in
                        RewardRow(
                            trophy: trophy,
                            claimed: claimedIDs.contains(trophy.uniqueID),
                            onClaim: { claimPoints(for: trophy) }
                        ) {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                selectedTrophy = trophy
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 32)
            }
            .blur(radius: selectedTrophy != nil ? 3 : 0)
            
            if showPointsSheet {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .zIndex(20)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showPointsSheet = false
                        }
                    }
                
                PointsAlert {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        showPointsSheet = false
                    }
                }
                .zIndex(21)
                .transition(.scale.combined(with: .opacity))
            }
            
            // Затемнение и sheet подробностей трофея
            if selectedTrophy != nil {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            selectedTrophy = nil
                        }
                    }
            }

            BottomSheetView(trophy: selectedTrophy) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    selectedTrophy = nil
                }
            }
            .onAppear { checkAndAwardPoints() }
            .animation(.easeInOut(duration: 0.35), value: selectedTrophy)
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Кастомный CornerRadius Extension
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct RewardsPreviews: PreviewProvider {
    static var previews: some View {
        RewardsView()
    }
}

extension Trophy: AnyTrophyProtocol {}
extension PremiumTrophy: AnyTrophyProtocol {}
extension SpecialTrophy: AnyTrophyProtocol {}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
