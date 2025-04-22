//
//  MenuRoute.swift
//  Sudoku
//
//  Created by Helter Skelter on 21/03/25.
//

import Foundation

public enum MenuRoute: Hashable {
    case levelSelection
    case game(GameState)
    case events
}
