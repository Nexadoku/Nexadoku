
import SwiftUI

public struct MenuRouter: RouterProtocol {
    private let route: MenuRoute
    
    public init(route: MenuRoute) {
        self.route = route
    }
    
    @ViewBuilder
    public func view() -> some View {
        switch route {
        case .levelSelection:
            LevelSelectionView()
        case .game(let state):
            GameView(state: state)
        case .events:
            EventsView()
        case .rewards:
            RewardsView()
        }
    }
}
