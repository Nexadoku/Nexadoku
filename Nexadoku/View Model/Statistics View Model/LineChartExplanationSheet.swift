
import SwiftUI

struct LineChartExplanationSheet: View {
    let stats: GameStats
    var body: some View {
        ZStack {
            DarkBackground().ignoresSafeArea()
            ScrollView {
                VStack(spacing: 18) {
                    Text("Line Chart")
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 24)
                    
                    StatsLineChart(stats: stats)
                        .padding()
                        .frame(height: 150)
                    
                    Text("The graph shows how many games you've won in the last 14 days. The higher the dot, the more wins you've had that day. Track your progress and aim for record-breaking streaks!")
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer(minLength: 12)
                }
            }
            .padding()
        }
    }
}
