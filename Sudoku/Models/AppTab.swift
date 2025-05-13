
import Foundation

public enum AppTab: Int, Hashable, Identifiable {
    case menu = 0
    case account
    
    public var id: Int { rawValue }
}
