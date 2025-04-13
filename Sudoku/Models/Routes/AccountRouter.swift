//
//  AccountRouter.swift
//  Sudoku
//
//  Created by Helter Skelter on 21/03/25.
//

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
        }
    }
}
