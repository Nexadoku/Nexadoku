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
    @StateObject private var languageSettings = LanguageSettings()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnbiarding = false
    
    var body: some Scene {
        WindowGroup {
                LaunchScreenView()
                    .environmentObject(navigator)
                    .environmentObject(languageSettings)
                    .environmentObject(GameSaveManager.shared)
                    .environmentObject(UnlockSheetManager())
                    .environment(\.locale, languageSettings.currentLocale)
        }
    }
}
