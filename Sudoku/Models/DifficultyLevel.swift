//
//  DifficultyLevel.swift
//  SUDOKU
//
//  Created by Helter Skelter on 13/04/25.
//

import Foundation

public enum DifficultyLevel: String, Codable, Sendable, Hashable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case master = "Master"
    case epic = "Epic"
    
    public var numberOfClues: Int {
        switch self {
        case .easy: 45
        case .medium: 40
        case .hard: 35
        case .master: 30
        case .epic: 25
        }
    }
}

extension DifficultyLevel: CaseIterable, Identifiable {
    public static var allCases: [DifficultyLevel] {
        return [.easy, .medium, .hard, .master, .epic]
    }
    
    public var id: String { rawValue }
    
    public var displayName: String { return rawValue }
}
