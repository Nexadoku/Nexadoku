
import SwiftUI

struct StatsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var navigator: Navigator
    @ObservedObject private var statsManager = StatisticsManager.shared
    
    @State private var selectedLevel: DifficultyLevel = .easy
    @State private var animate = false
    
    var stats: GameStats {
        statsManager.stats(for: selectedLevel)
    }

    var body: some View {
        ZStack {
            SystemDarkBackground()
            ScrollView {
                VStack(spacing: 30) {
                    HStack {
                        Button {
                            dismiss()
                            VibrationManager.shared.lightImpact()
                        } label:  {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                        }
                        
                        
                        Text("STATISTICS")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                            .opacity(animate ? 1 : 0)
                            .scaleEffect(animate ? 1 : 0.95)
                            .animation(.easeOut(duration: 0.8).delay(0.1), value: animate)
                        
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .shadow(radius: 10)
                            .opacity(animate ? 1 : 0)
                            .animation(.easeInOut(duration: 0.8).delay(0.1), value: animate)
                        
                        Spacer()
                    }
                    
                    
                    .onChange(of: selectedLevel) { _ in
                        VibrationManager.shared.lightImpact()
                    }
                    
                    Picker("Difficulty", selection: $selectedLevel) {
                        ForEach(DifficultyLevel.allCases) { level in
                            Text(level.displayName).tag(level)
                        }
                        
                    }
                    .pickerStyle(.segmented)
                    .colorScheme(.dark)
                    .opacity(animate ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.2), value: animate)
                    
                    statsCapsule
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : 20)
                        .animation(.easeOut(duration: 0.5).delay(0.1), value: animate)
                    
                    Spacer()
                }
                .padding()
            }
            
            .onAppear {
                animate = true
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    var statsCapsule: some View {
            VStack(spacing: 28) {
                Text("Game")
                    .foregroundColor(.white)
                    .font(.title3.bold())
                statRow(title: "Total Games", value: "\(stats.totalGames)")
                statRow(title: "Wins", value: "\(stats.totalWins)")
                statRow(title: "Flawless Wins", value: "\(stats.flawlessWins)")
                statRow(title: "Win %", value: String(format: "%.0f%%", stats.winPercentage))
                Text("Time")
                    .foregroundColor(.white)
                    .font(.title3.bold())
                statRow(title: "Best Time", value: formatTime(stats.bestTime))
                statRow(title: "Average Time", value: formatTime(stats.averageTime))
                Text("Streak")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                statRow(title: "Current Winning Streak", value: "\(stats.currentWinningStreak)")
                statRow(title: "Best Winning Streak", value: "\(stats.bestWinningStreak)")
            }
        }
    
    func formatTime(_ seconds: Int?) -> String {
        guard let seconds = seconds else { return "-" }
        return String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
    
    func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.purple, lineWidth: 2)
        )
    }
}

struct StatsViewPreviews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(Navigator())
           
    }
}

