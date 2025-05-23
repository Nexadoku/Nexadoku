
import SwiftUI

struct RewardsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var progress = ProgressManager.shared
    @State private var selectedTrophy: Trophy? = nil

    var trophies: [Trophy] {
        DifficultyLevel.allCases.flatMap { level in
            let wins = progress.winsCount(for: level)
            return [
                Trophy(level: level, type: .bronze, requiredWins: 10, currentWins: wins),
                Trophy(level: level, type: .silver, requiredWins: 30, currentWins: wins),
                Trophy(level: level, type: .gold, requiredWins: 60, currentWins: wins)
            ]
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            BlurView(style: .systemChromeMaterialDark)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 24) {
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
                    }
                    .padding()
                    
                    ForEach(DifficultyLevel.allCases, id: \.self) { level in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(level.rawValue.capitalized)
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            HStack(spacing: 20) {
                                ForEach(trophies.filter { $0.level == level }) { trophy in
                                    VStack(spacing: 10) {
                                        ZStack {
                                            Image(trophy.imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                                .opacity(trophy.isUnlocked ? 1 : 0.3)
                                            if !trophy.isUnlocked {
                                                Image(systemName: "lock.fill")
                                                    .foregroundColor(.white.opacity(0.8))
                                            }
                                        }
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.35)) {
                                                selectedTrophy = trophy
                                            }
                                        }
                                        ProgressBar(current: trophy.currentWins, total: trophy.requiredWins)
                                            .frame(height: 8)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .blur(radius: selectedTrophy != nil ? 3 : 0)

            // Animated Bottom Sheet
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
        .animation(.easeInOut(duration: 0.35), value: selectedTrophy)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - BottomSheetView

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
                            Text("✅ Trophy unlocked!")
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

// MARK: - Custom CornerRadius Extension

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

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
