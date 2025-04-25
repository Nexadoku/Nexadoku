//
//  Destination.swift
//  Sudoku
//
//  Created by Helter Skelter on 21/03/25.
//

import Foundation

public enum Destination: Hashable {
    case menu(MenuRoute)
    case account(AccountRoute)
    case event(EventsRoute)
    case level(LevelRoute)
    case menuTab(MenuTabRoute)
}
