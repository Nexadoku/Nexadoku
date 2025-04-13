//
//  SudokuApp.swift
//  Sudoku
//
//  Created by Helter Skelter on 17/03/25.
//

import SwiftUI

@main
struct SudokuApp: App {
    @StateObject private var navigator = Navigator()
    
    var body: some Scene {
        WindowGroup {
            MenuTabView()
                .environmentObject(navigator)
        }
    }
}
