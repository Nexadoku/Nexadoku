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
            if hasSeenOnbiarding {
                LaunchScreenView()
                    .environmentObject(navigator)
                    .environmentObject(languageSettings)
                    .environmentObject(GameSaveManager.shared)
                    .environment(\.locale, languageSettings.currentLocale)
            } else {
                OnboardingView()
                    .environmentObject(navigator)
                    .environmentObject(languageSettings)
                    .environmentObject(GameSaveManager.shared)
                    .environment(\.locale, languageSettings.currentLocale)
            }
        }
    }
}
