
import Foundation
import UIKit

class StatisticsManager: ObservableObject {
    @Published private(set) var stats: [DifficultyLevel: GameStats]
    
    static let shared = StatisticsManager()
    private let key = "sudoku_stats_by_level"
    
    private init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([DifficultyLevel: GameStats].self, from: data) {
            stats = decoded
        } else {
            stats = Dictionary(uniqueKeysWithValues: DifficultyLevel.allCases.map { ($0, GameStats()) })
        }
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func recordGame(won: Bool, flawless: Bool, time: Int?, difficulty: DifficultyLevel) {
        var currentStats = stats[difficulty] ?? GameStats()
        
        currentStats.totalGames += 1
        
        if won {
            currentStats.totalWins += 1
            currentStats.currentWinningStreak += 1
            currentStats.bestWinningStreak = max(currentStats.bestWinningStreak, currentStats.currentWinningStreak)
            
            let today = Calendar.current.startOfDay(for: Date())
            currentStats.winDates.append(today)
            
        } else {
            currentStats.currentWinningStreak = 0
        }
        
        if flawless {
            currentStats.flawlessWins += 1
        }
        
        if won, let time = time {
            currentStats.totalTime += time
            currentStats.gamesWithTime += 1
            if let best = currentStats.bestTime {
                currentStats.bestTime = min(best, time)
            } else {
                currentStats.bestTime = time
            }
        }
        
        stats[difficulty] = currentStats
        save()
    }
    
    func stats(for difficulty: DifficultyLevel) -> GameStats {
        stats[difficulty] ?? GameStats()
    }
    
    func resetAllStats() {
        stats = Dictionary(uniqueKeysWithValues: DifficultyLevel.allCases.map { ($0, GameStats()) })
        save()
    }
}
