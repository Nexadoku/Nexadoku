
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
    
    var averageTime: Int? {
        guard gamesWithTime > 0 else { return nil }
        return totalTime / gamesWithTime
    }
    
    var winPercentage: Double {
        guard totalGames > 0 else { return 0 }
        return (Double(totalWins) / Double(totalGames)) * 100
    }
}
