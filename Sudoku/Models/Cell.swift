//
//  Cell.swift
//  SUDOKU
//
//  Created by Helter Skelter on 22/04/25.
//

import Foundation


public struct Cell: Identifiable, Hashable, Codable {
    public var id = UUID()
    public var value: Int
    public var isOriginal: Bool
    public var row: Int
    public var col: Int
    public var isIncorrect: Bool = false
    public var notes: Set<Int> = []
}

struct CellCoordinate: Hashable {
    let row: Int
    let col: Int
}
