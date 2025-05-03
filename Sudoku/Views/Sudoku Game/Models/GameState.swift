//
//  GameState.swift
//  SUDOKU
//
//  Created by Helter Skelter on 22/04/25.
//

import Foundation

public enum GameState: Hashable, Sendable {
    case new(level: DifficultyLevel)
    case saved(game: SavedGame)
    
    public var isNewGame: Bool {
        switch self {
        case .new: true
        default: false
        }
    }
    
}
