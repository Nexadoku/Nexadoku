
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
        case .help:
            PrivacyPolicy()
        case .privacyPolicy:
            HelpView()
        case .terms:
            TermsAndConditions()
        case .premium:
            AboutPremium()
        }
    }
}
