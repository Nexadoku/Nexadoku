
import SwiftUI

public struct EventsRouter: RouterProtocol {
    private let route: EventsRoute
    
    public init(route: EventsRoute) {
        self.route = route
    }
    
    @ViewBuilder
    public func view() -> some View {
        switch route {
        case .mathPuzzle:
            MathPuzzleView()
        }
    }
}
