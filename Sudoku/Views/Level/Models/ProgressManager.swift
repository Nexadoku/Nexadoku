
import Foundation

class ProgressManager: ObservableObject {
    static let shared = ProgressManager()
    
    @Published var wins: [DifficultyLevel: Int] = [:]
    
    private let defaultsKey = "sudoku_wins"
    
    private init() {
        loadWins()
    }
    
    func recordWin(for level: DifficultyLevel) {
        wins[level, default: 0] += 1
        saveWins()
    }
    
    func winsCount(for level: DifficultyLevel) -> Int {
        wins[level, default: 0]
    }
    
    func isLevelUnlocked(_ level: DifficultyLevel) -> Bool {
        switch level {
        case .easy:
            return true
        case .medium:
            return winsCount(for: .easy) >= 2
        case .hard:
            return winsCount(for: .medium) >= 4
        case .master:
            return winsCount(for: .hard) >= 6
        case .epic:
            return winsCount(for: .master) >= 8
        }
    }
    
    private func loadWins() {
        if let data = UserDefaults.standard.dictionary(forKey: defaultsKey) as? [String: Int] {
            for (key, value) in data {
                if let level = DifficultyLevel(rawValue: key) {
                    wins[level] = value
                }
            }
        }
    }
    
    private func saveWins() {
        let dict = wins.reduce(into: [String: Int]()) { $0[$1.key.rawValue] = $1.value }
        UserDefaults.standard.set(dict, forKey: defaultsKey)
    }
}
