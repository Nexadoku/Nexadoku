import SwiftUI

struct StatsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var navigator: Navigator
    @ObservedObject private var statsManager = StatisticsManager.shared

    @State private var selectedLevel: DifficultyLevel = .easy
    @State private var animate = false
    @State private var pieChartProgress: Double = 0
    
    @State private var showCalendarSheet = false
    @State private var showLineChartSheet = false

    var stats: GameStats {
        statsManager.stats(for: selectedLevel)
    }

    var body: some View {
        ZStack {
            SystemBackground()
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
                    .background(
                        LinearGradient(colors: [.purple.opacity(0.5), .black.opacity(0.5), .purple.opacity(0.5), .black.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(10)
                    .opacity(animate ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.2), value: animate)
                 
                        StatsPieChart(stats: stats, animatedPercent: pieChartProgress)
                            .shadow(radius: 15)
                            .opacity(animate ? 1 : 0)
                            .offset(y: animate ? 0 : 24)
                            .animation(.easeOut(duration: 0.8).delay(0.15), value: animate)
                        
                        HStack(spacing: 18) {
                            legendDot(.purple, "Wins")
                            legendDot(.green, "Flawless")
                            legendDot(.clear, "Losses")
                        }
                        
                        StatsLineChart(stats: stats)
                        .onTapGesture {
                            showLineChartSheet = true
                        }
                        StatsCalendarView(winDates: stats.winDates)
                        .onTapGesture {
                            showCalendarSheet = true
                        }
                    
                   

                    statsCapsule
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : 20)
                        .animation(.easeOut(duration: 0.5).delay(0.1), value: animate)

                    Spacer()
                }
                .padding()
            }
            .sheet(isPresented: $showLineChartSheet) {
                LineChartExplanationSheet(stats: stats)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showCalendarSheet) {
                CalendarExplanationSheet(winDates: stats.winDates)
                    .presentationDetents([.medium])
            }
            .onAppear {
                animate = true
                // Анимация PieChart
                pieChartProgress = 0
                withAnimation(.easeOut(duration: 1.2)) {
                    pieChartProgress = 1
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    var statsCapsule: some View {
        VStack(spacing: 28) {
            Text("Game")
                .foregroundColor(.white)
                .font(.title3.bold())
            VStack {
                statRow(title: "Total Games", value: "\(stats.totalGames)")
                Divider().background(.white.opacity(0.5))
                statRow(title: "Wins", value: "\(stats.totalWins)")
                Divider().background(.white.opacity(0.5))
                statRow(title: "Flawless Wins", value: "\(stats.flawlessWins)")
                Divider().background(.white.opacity(0.5))
                statRow(title: "Win %", value: String(format: "%.0f%%", stats.winPercentage))
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.purple, lineWidth: 5)
                    .background(
                        LinearGradient(colors: [.black.opacity(0.5), .purple.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                    )
                    .cornerRadius(20)
            )
            Text("Time")
                .foregroundColor(.white)
                .font(.title3.bold())
            VStack {
                statRow(title: "Best Time", value: formatTime(stats.bestTime))
                Divider().background(.white.opacity(0.5))
                statRow(title: "Average Time", value: formatTime(stats.averageTime))
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.purple, lineWidth: 5)
                    .background(
                        LinearGradient(colors: [.black.opacity(0.5), .purple.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                    )
                    .cornerRadius(20)
            )
            Text("Streak")
                .font(.title3.bold())
                .foregroundColor(.white)
            VStack {
                statRow(title: "Current Winning Streak", value: "\(stats.currentWinningStreak)")
                Divider().background(.white.opacity(0.5))
                statRow(title: "Best Winning Streak", value: "\(stats.bestWinningStreak)")
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.purple, lineWidth: 5)
                    .background(
                        LinearGradient(colors: [.black.opacity(0.5), .purple.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                    )
                    .cornerRadius(20)
            )
        }
    }

    func formatTime(_ seconds: Int?) -> String {
        guard let seconds = seconds else { return "-" }
        return String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }

    func legendDot(_ color: Color, _ label: String) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 14, height: 14)
            Text(label).foregroundColor(.white.opacity(0.7)).font(.caption)
        }
    }

    func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
        .padding()
    }
}

struct StatsViewPreviews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(Navigator())
    }
}
