
import SwiftUI

struct RewardsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var progress = ProgressManager.shared
    @State private var selectedTrophy: Trophy? = nil
    @State private var showPointsSheet = false
    
    @AppStorage("totalPoints") private var totalPoints: Int = 0
    @AppStorage("earnedTrophyIDs") private var earnedTrophyIDs: String = ""

    var trophies: [Trophy] {
        DifficultyLevel.allCases.flatMap { level in
            let wins = progress.winsCount(for: level)
            return [
                Trophy(level: level, type: .bronze, requiredWins: 18, currentWins: wins),
                Trophy(level: level, type: .silver, requiredWins: 30, currentWins: wins),
                Trophy(level: level, type: .gold, requiredWins: 45, currentWins: wins)
            ]
        }
    }
    
    private func points(for trophy: Trophy) -> Int {
        switch trophy.type {
        case .bronze: return 10
        case .silver: return 30
        case .gold: return 60
        }
    }
   
    private func checkAndAwardPoints() {
        var ids = Set(earnedTrophyIDs.split(separator: ",").map { String($0) })
        var newPoints = 0
        
        for trophy in trophies where trophy.isUnlocked {
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
            SystemDarkBackground()
            
            ScrollView {
                VStack(spacing: 18) {
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .heavy))
                        }
                        Text("REWARDS")
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .heavy))
                        Spacer()
                        
                        Button {
                            withAnimation(.spring(response: 0.38, dampingFraction: 0.78)) {
                                showPointsSheet = true
                            }
                        } label : {
                            HStack {
                                Text("\(totalPoints)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 19, weight: .heavy))
                                    .shadow(radius: 4)
                                Image("coin")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.purple, lineWidth: 2)
                            )
                        }
                    }
                    .padding(.top, 12)
                    .padding(.horizontal)
                    
                    ForEach(trophies) { trophy in
                        RewardRow(trophy: trophy) {
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
                LinearGradient(colors: [.purple.opacity(0.3), .black.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
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
        }
        .onAppear { checkAndAwardPoints() }
        .animation(.easeInOut(duration: 0.35), value: selectedTrophy)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Карточка одной награды
struct RewardRow: View {
    let trophy: Trophy
    var onTap: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(trophy.level.rawValue.capitalized) – \(trophy.type.rawValue.capitalized) Trophy")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                if trophy.isUnlocked {
                    Text("Unlocked! 🏆")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.green)
                } else {
                    Text("Win \(max(trophy.requiredWins - trophy.currentWins, 0)) more time(s) to unlock")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white.opacity(0.68))
                }
                ProgressBar(current: trophy.currentWins, total: trophy.requiredWins)
                    .frame(height: 7)
                    .padding(.top, 5)
                    .padding(.trailing, 24)
            }
            Spacer()
            ZStack {
                Image(trophy.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 54, height: 54)
                    .opacity(trophy.isUnlocked ? 1 : 0.23)
                if !trophy.isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(LinearGradient(colors: [.white, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(radius: 4)
                }
            }
            .onTapGesture { onTap() }
        }
        .padding(16)
        .background(
            LinearGradient(colors: [Color.purple.opacity(0.22), Color.black.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: .purple.opacity(0.18), radius: 12, x: 0, y: 6)
    }
}

// MARK: - BottomSheetView (Sheet подробностей трофея)
struct BottomSheetView: View {
    let trophy: Trophy?
    let onClose: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                if let trophy = trophy {
                    VStack(spacing: 20) {
                        Capsule()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 50, height: 6)
                            .padding(.top, 12)
                        Image(trophy.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .shadow(color: .white, radius: 30)
                            .shadow(color: .purple, radius: 60)
                        Text("\(trophy.level.rawValue.capitalized) – \(trophy.type.rawValue.capitalized) Trophy")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Text("Win the \(trophy.level.rawValue.capitalized) level \(trophy.requiredWins) times to unlock this trophy.")
                            .multilineTextAlignment(.center)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.horizontal)
                        if trophy.isUnlocked {
                            Text("Trophy unlocked!")
                                .foregroundColor(.green)
                                .font(.headline)
                        } else {
                            Text("Progress: \(trophy.currentWins)/\(trophy.requiredWins)")
                                .foregroundColor(.white.opacity(0.8))
                                .font(.subheadline)
                        }
                        Button(action: onClose) {
                            Text("Close")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .padding(.horizontal)
                    }
                    .background(
                        LinearGradient(colors: [.purple.opacity(0.2), .black], startPoint: .top, endPoint: .bottom)
                            .ignoresSafeArea(edges: .bottom)
                    )
                    .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
            .offset(y: trophy != nil ? 0 : geometry.size.height)
            .opacity(trophy != nil ? 1 : 0)
            .allowsHitTesting(trophy != nil)
        }
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


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
