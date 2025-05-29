
import SwiftUI

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
