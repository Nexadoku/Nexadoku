
import SwiftUI

public struct LevelRouter: RouterProtocol {
    private let route: LevelRoute
    
    public init(route: LevelRoute) {
        self.route = route
    }
    
    @ViewBuilder
    public func view() -> some View {
        switch route {
        case .game(let level):
            GameView(level: level)
        }
    }
}
