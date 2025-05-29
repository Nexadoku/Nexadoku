
import SwiftUI

struct Trophy: Identifiable, Equatable {
    let id = UUID()
    let level: DifficultyLevel
    let type: TrophyType
    let requiredWins: Int
    let currentWins: Int
    
    var isUnlocked: Bool {
        currentWins >= requiredWins
    }
    
    static func == (lhs: Trophy, rhs: Trophy) -> Bool {
        lhs.id == rhs.id
    }
    
    var title: String {
        "Win \(level.rawValue.capitalized) \(requiredWins)"
    }
}

extension Trophy {
    var imageName: String {
        "\(level.rawValue.lowercased())_\(type.rawValue.lowercased())_trophy"
    }
}
