
import SwiftUI

protocol AnyTrophyProtocol {
    var uniqueID: String { get }
    var isUnlocked: Bool { get }
}

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

struct SpecialTrophy: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let isUnlocked: Bool
    let imageName: String
    var uniqueID: String { "\(title)_special" }
}


struct PremiumTrophy: Identifiable {
    let id: UUID
    let level: DifficultyLevel
    let requiredWins: Int
    let currentWins: Int
    let imageName: String
    let title: String
    let description: String
    var isUnlocked: Bool { currentWins >= requiredWins }
    var uniqueID: String { "\(level.rawValue)_premium" }
}


enum TrophyType: String, CaseIterable {
    case bronze, silver, gold
    
    var imageName: String {
        switch self {
        case .bronze: return "bronzeTrophy"
        case .silver: return "silverTrophy"
        case .gold: return "goldTrophy"
        }
    }
}




extension Trophy {
    var imageName: String {
        "\(level.rawValue.lowercased())_\(type.rawValue.lowercased())_trophy"
    }
}

extension Trophy {
    var uniqueID: String {
            "\(level.rawValue)_\(type.rawValue)"
        }
}
