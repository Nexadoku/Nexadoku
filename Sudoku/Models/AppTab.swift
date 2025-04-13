//
//  AppTab.swift
//  Sudoku
//
//  Created by Helter Skelter on 21/03/25.
//

import Foundation

public enum AppTab: Int, Hashable, Identifiable {
    case menu = 0
    case account
    
    public var id: Int { rawValue }
}
