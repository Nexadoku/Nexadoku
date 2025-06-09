
import Foundation

struct GameStats: Codable {
    var totalGames: Int = 0
    var totalWins: Int = 0
    var flawlessWins: Int = 0
    var bestTime: Int? = nil
    var totalTime: Int = 0
    var gamesWithTime: Int = 0
    var currentWinningStreak: Int = 0
    var bestWinningStreak: Int = 0
    var winDates: [Date] = []
    
    var averageTime: Int? {
        guard gamesWithTime > 0 else { return nil }
        return totalTime / gamesWithTime
    }
    
    var winPercentage: Double {
        guard totalGames > 0 else { return 0 }
        return (Double(totalWins) / Double(totalGames)) * 100
    }
}

extension GameStats {
    func winsPerDayLast14Days() -> [Int] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var result: [Int] = []
        for i in (0..<14).reversed() {
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let count = winDates.filter { calendar.isDate($0, inSameDayAs: date) }.count
            result.append(count)
        }
        return result
    }
}
