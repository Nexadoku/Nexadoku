//
//  MenuRouter.swift
//  Sudoku
//
//  Created by Helter Skelter on 21/03/25.
//

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
        case .game:
            GameView(level: .easy)
        case .events:
            EventsView()
        }
    }
}
