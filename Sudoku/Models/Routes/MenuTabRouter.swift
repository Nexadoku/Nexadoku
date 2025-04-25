
import SwiftUI

public struct MenuTabRouter: RouterProtocol {
    private let route: MenuTabRoute
    
    public init(route: MenuTabRoute) {
        self.route = route
    }
    
    @ViewBuilder
    public func view() -> some View {
        switch route {
        case .mainMenu:
            MenuView()
        case .accountMenu:
            AccountView()
        }
    }
}
