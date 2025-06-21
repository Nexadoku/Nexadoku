
import Foundation

enum RewardTab: String, CaseIterable, Identifiable {
    case levels = "Levels"
    case premium = "Premium"
    case special = "Special"
    case my = "My"
    var id: String { rawValue }
}
