
import SwiftUI

public struct AccountRouter: RouterProtocol {
    private let route: AccountRoute
    
    public init(route: AccountRoute) {
        self.route = route
    }
    
    @ViewBuilder
    public func view() -> some View {
        switch route {
        case .statistics:
            StatsView()
        case .settings:
            SettingsView()
        case .aboutPremium:
            PrivacyPolicy()
        case .help:
            HelpView()
        }
    }
}
