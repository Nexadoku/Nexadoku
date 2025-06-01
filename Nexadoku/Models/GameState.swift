
import Foundation

public enum GameState: Hashable, Sendable {
    case new(level: DifficultyLevel)
    case saved(game: SavedGame)
    
    public var isNewGame: Bool {
        switch self {
        case .new: true
        default: false
        }
    }
}
