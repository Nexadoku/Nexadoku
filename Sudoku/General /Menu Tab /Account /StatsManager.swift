
import Foundation

class StatsManager: ObservableObject {
    @Published private(set) var stats: GameStats
    
    static let shared = StatsManager()
    private let key = "sudoku_stats"
    
    private init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(GameStats.self, from: data) {
            stats = decoded
        } else {
            stats = GameStats()
        }
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func recordGame(won: Bool, flawless: Bool, time: Int?) {
        stats.totalGames += 1
        
        if won {
            stats.totalWins += 1
            stats.currentWinningStreak += 1
            stats.bestWinningStreak = max(stats.bestWinningStreak, stats.currentWinningStreak)
        } else {
            stats.currentWinningStreak = 0
        }
        
        if flawless {
            stats.flawlessWins += 1
        }
        
        if let time = time {
            stats.totalTime += time
            stats.gamesWithTime += 1
            
            if let best = stats.bestTime {
                stats.bestTime = min(best, time)
            } else {
                stats.bestTime = time
            }
        }
        
        save()
        
    }
}
