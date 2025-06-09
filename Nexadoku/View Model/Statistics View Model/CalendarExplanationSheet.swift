
import SwiftUI

struct CalendarExplanationSheet: View {
    let winDates: [Date]
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Text("Game Calendar")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundColor(.purple)
                    .padding(.top, 24)
                
                StatsCalendarView(winDates: winDates)
                    .frame(height: 200)
                
                Text("The calendar shows the days when you will win. The cells are highlighted in color - the more wins per day, the brighter the highlight. Track your activity and do not miss days!")
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer(minLength: 12)
            }
        }
        .padding()
        .background(DarkBackground().ignoresSafeArea())
    }
}
