
import SwiftUI

struct StatsCalendarView: View {
    let winDates: [Date]

    private let calendar = Calendar.current
    private let daysInMonth: Int
    private let firstWeekday: Int
    private let currentMonth: Date

    init(winDates: [Date]) {
        self.winDates = winDates
        self.currentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        self.daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)!.count
        self.firstWeekday = calendar.component(.weekday, from: currentMonth) - 1
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(currentMonth, format: .dateTime.year().month())
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 6)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 6) {
                ForEach(0..<firstWeekday, id: \.self) { _ in
                    Color.clear.frame(height: 24)
                }
                ForEach(1...daysInMonth, id: \.self) { day in
                    let date = calendar.date(byAdding: .day, value: day - 1, to: currentMonth)!
                    let isWin = winDates.contains(where: { calendar.isDate($0, inSameDayAs: date) })
                    ZStack {
                        if isWin {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(LinearGradient(colors: [.purple, .indigo], startPoint: .top, endPoint: .bottom))
                                .shadow(color: .purple.opacity(0.25), radius: 5, x: 0, y: 2)
                                .frame(height: 24)
                        }
                        Text("\(day)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(isWin ? .white : .white.opacity(0.6))
                            .frame(height: 24)
                    }
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [.purple.opacity(0.12), .indigo.opacity(0.13)], startPoint: .top, endPoint: .bottom))
                    .shadow(color: .indigo.opacity(0.08), radius: 12, x: 0, y: 4)
            )
        }
        .padding(.top, 10)
    }
}
