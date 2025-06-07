
import SwiftUI

struct StatsPieChart: View {
    let stats: GameStats
    
    var winPercent: Double { stats.winPercentage }
    var flawlessPercent: Double {
        stats.totalGames > 0 ? Double(stats.flawlessWins) / Double(stats.totalGames) * 100 : 0
    }
    var losePercent: Double {
        100 - winPercent
    }
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(losePercent / 100))
                .stroke(Color.gray.opacity(0.3), lineWidth: 26)
                .rotationEffect(.degrees(-90))
            Circle()
                .trim(from: 0, to: CGFloat(winPercent / 100))
                .stroke(
                    LinearGradient(colors: [.purple, .indigo], startPoint: .top, endPoint: .bottom),
                    style: StrokeStyle(lineWidth: 26, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            Circle()
                .trim(from: 0, to: CGFloat(flawlessPercent / 100))
                .stroke(
                    LinearGradient(colors: [.yellow, .green], startPoint: .top, endPoint: .bottom),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            VStack(spacing: 2) {
                Text("\(Int(winPercent))%")
                    .font(.system(size: 38, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                Text("Wins")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 16, weight: .medium))
            }
        }
        .frame(width: 170, height: 170)
        .padding(.top, 22)
    }
}
