
import Foundation

public struct SavedCell: Codable, Hashable, Sendable {
    public let value: Int
    public let isOriginal: Bool
    public let row: Int
    public let col: Int
    public let isIncorect: Bool
    public let notes: [Int]
}

public struct SavedGame: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let level: DifficultyLevel
    public let saveGrid: [[SavedCell]]
    public let solutionGrid: [[Int]]
    public let mistakes: Int
    public let elapsedTime: Int
    public let createdAt: Date
}


final class GameSaveManager: ObservableObject {
    @Published var game: SavedGame?
    
    static let shared = GameSaveManager()
    
    private let key = "savedGames"
    
    init() {
        load()
    }
    
    func save(game: SavedGame) {
        save(game)
        load()
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let game = try? JSONDecoder().decode(SavedGame.self, from: data) else {
                  return
        }
        
        self.game = game
    }
    
    private func save(_ game: SavedGame) {
        guard let data = try? JSONEncoder().encode(game) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
