//
//  EventsRouter.swift
//  SUDOKU
//
//  Created by Helter Skelter on 03/04/25.
//

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
