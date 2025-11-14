import Foundation
import SwiftUI
import Combine
import UIKit

@MainActor
final class Game: ObservableObject {
    @Published var grid: [[Cell]] = []
    @Published var selectedCell: (row: Int, col: Int)? = nil
    @Published var mistakes: Int = 0
    @Published var gameOver: Bool = false
    @Published var highlightedCells: Set<CellCoordinate> = []
    @Published var remainingHints: Int = 3
    @Published var pencilMode: Bool = false
    @Published var isWon: Bool = false
    @Published var finalTime: Int = 0
    @Published var lockedNumberInput: Int? = nil
    @Published var isLoading: Bool = false
    @Published var completedLines: Set<Int> = []
    @Published var completedNumbers: Int? = nil
    
    @AppStorage("mistakesEnabled") var mistakesEnabled = true
    @AppStorage("hintsUsedToday") private var hintsUsedToday = 0
    @AppStorage("lastHintResetDate") private var lastHintResetDate = ""
    @AppStorage("highlightsEnabled") private var highlightsEnabled = true
    @AppStorage("highlightLinesEnabled") private var highlightLinesEnabled = false
    @AppStorage("isPremium") private var isPremium = false
    
    var timer: GameTimer
    
    var usedNumbersCount: [Int: Int] {
        var count: [Int: Int] = [:]
        for row in grid {
            for cell in row {
                if cell.value != 0 {
                    count[cell.value, default: 0] += 1
                }
            }
        }
        return count
    }
    
    private let state: GameState
    var level: DifficultyLevel
    private var solutionGrid: [[Int]] = []
    private var timerCancellable: AnyCancellable?
    
    // MARK: - Initializers
    
    convenience init(state: GameState) {
        switch state {
        case .new(let level):
            self.init(level: level, state: state)
        case .saved(let game):
            self.init(from: game, state: state)
        }
    }
    
    private init(level: DifficultyLevel, state: GameState) {
        self.state = state
        self.level = level
        self.timer = GameTimer()
    }
    
    private init(from savedGame: SavedGame, state: GameState) {
        self.level = savedGame.level
        self.grid = Game.convertToLiveGrid(from: savedGame.saveGrid)
        self.solutionGrid = savedGame.solutionGrid
        self.mistakes = savedGame.mistakes
        self.timer = GameTimer(accumulatedTime: savedGame.elapsedTime)
        self.state = state
    }
    
    deinit {
        timer.stop()
    }
    
    func saveCurrentGame() {
        let savedGrid = convertToSaveGrid(from: grid)
        let savedGame = SavedGame(
            id: UUID(),
            level: level,
            saveGrid: savedGrid,
            solutionGrid: solutionGrid,
            mistakes: mistakes,
            elapsedTime: timer.elapsedTime,
            createdAt: Date()
        )
        
        GameSaveManager.shared.save(game: savedGame)
    }
    
    func loadGame() async {
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        resetHintsIfNeeded()
        
        if state .isNewGame {
            await generateSudokuGrid()
        }
        
        remainingHints = max(0, 3 - hintsUsedToday)
        
        startTimer()
    }
    
    func startTimer() {
        timer.start()
    }
    
    func togglePencilMode() {
        pencilMode.toggle()
    }
    
    func checkCompletedLines() {
        var completedRows = Set<Int>()
        var completedColumns = Set<Int>()
        
        for row in 0..<9 {
            if grid[row].allSatisfy({ $0.value != 0 }) {
                completedRows.insert(row)
            }
        }
        
        for col in 0..<9 {
            if (0..<9).allSatisfy({ grid[$0][col].value != 0 }) {
                completedColumns.insert(col)
            }
        }
        completedLines = completedRows.union(completedColumns)
    }
    
    func canUseHint() -> Bool {
        resetHintsIfNeeded()
        return hintsUsedToday < 3
    }
    
    func useHint() {
        resetHintsIfNeeded()
        
        guard remainingHints > 0 else { return }
        guard let selected = selectedCell else { return }
        guard !grid[selected.row][selected.col].isOriginal else { return }
        
        let correctValue = solutionGrid[selected.row][selected.col]
        grid[selected.row][selected.col].value = correctValue
        grid[selected.row][selected.col].notes = []
      
        hintsUsedToday += 1
        remainingHints = max(0, 3 - hintsUsedToday)
    }
    
    func coordinatesOfAllSameValue() -> [CellCoordinate] {
        guard highlightsEnabled, isPremium else { return [] }
        guard let selected = selectedCell else { return [] }
        let val = grid[selected.row][selected.col].value
        guard val != 0 else { return [] }
        var coords: [CellCoordinate] = []
        for r in 0..<9 {
            for c in 0..<9 {
                if grid[r][c].value == val {
                    coords.append(CellCoordinate(row: r, col: c))
                }
            }
        }
        return coords
    }
    
    func restart() {
        for row in 0..<9 {
            for col in 0..<9 {
                if !grid[row][col].isOriginal {
                    grid[row][col].value = 0
                    grid[row][col].notes = []
                    grid[row][col].isIncorrect = false
                } else {
                    grid[row][col].isIncorrect = false
                    grid[row][col].notes = []
                }
            }
        }
        
        mistakes = 0
        useHint()
        selectedCell = nil
        highlightedCells = []
        isWon = false
        gameOver = false
        lockedNumberInput = nil
        timer.reset()
        timer.start()
    }
    
    static func convertToLiveGrid(from savedGrid: [[SavedCell]]) -> [[Cell]] {
        savedGrid.map { row in
            row.map { saved in
                Cell(
                    value: saved.value,
                    isOriginal: saved.isOriginal,
                    row: saved.row,
                    col: saved.col,
                    isIncorrect: saved.isIncorect,
                    notes: Set(saved.notes)
                )
            }
        }
    }
    
    func eraseValue() {
        guard let selected = selectedCell else { return }
        guard !grid[selected.row][selected.col].isOriginal else { return }
        
        grid[selected.row][selected.col].value = 0
        grid[selected.row][selected.col].notes = []
        grid[selected.row][selected.col].isIncorrect = false
    }
    
    func generateSudokuGrid() async {
        let start = Date()
        let fullGrid = await Task.detached(priority: .userInitiated) {
            SudokuGenerator.generateSolvedGrid()
        }.value
        
        let gameGrid = await Task.detached(priority: .userInitiated) {
            await SudokuGenerator.removeNumbers(from: fullGrid, clues: self.level.numberOfClues)
        }.value
        
        solutionGrid = fullGrid
        grid = gameGrid
        
        #if DEBUG
        let duration = Date().timeIntervalSince(start)
        print("Sudoku grid generation took \(duration) seconds")
        #endif
    }
    
    func selectCell(row: Int, col: Int) {
        selectedCell = (row, col)
        updateHighlights(row: row, col: col)
        inputLockedNumberIfNeeded()
    }
    
    func isSelected(row: Int, col: Int) -> Bool {
        return selectedCell?.row == row && selectedCell?.col == col
    }
    
    func isHighlighted(row: Int, col: Int) -> Bool {
        return highlightedCells.contains(CellCoordinate(row: row, col: col))
    }
    
    func updateValue(_ value: Int) {
        guard let selected = selectedCell, !grid[selected.row][selected.col].isOriginal else {
            return
        }
        
        if let lockedNumber = lockedNumberInput, value != lockedNumber {
            return
        }
        
        let correctValue = solutionGrid[selected.row][selected.col]
        
        if pencilMode {
            grid[selected.row][selected.col].notes.insert(value)
            return
        }
        
        if value == correctValue {
            grid[selected.row][selected.col].value = value
            grid[selected.row][selected.col].isIncorrect = false
            grid[selected.row][selected.col].notes.remove(value)
            
            SoundManager.shared.playSound(named: "SelectCell")
            VibrationManager.shared.lightImpact()
            
            removeDraftsAround(row: selected.row, col: selected.col)
            updateHighlights(row: selected.row, col: selected.col)
            
            let count = grid.flatMap { $0 }.filter { $0.value == value }.count
            if count == 9 {
                completedNumbers = value
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.completedNumbers = nil
                }
            }
            checkWin()
        } else {
            grid[selected.row][selected.col].value = value
            grid[selected.row][selected.col].isIncorrect = true
            updateHighlights(row: selected.row, col: selected.col)
            if mistakesEnabled {
                mistakes += 1
                
                SoundManager.shared.playSound(named: "error")
                VibrationManager.shared.strongErrorVibration()
                
                if mistakes >= 3 {
                    isWon = false
                    gameOver = true
                    gameOverDueToMistakes()
                }
            } else {
                SoundManager.shared.playSound(named: "SelectCell")
                VibrationManager.shared.lightImpact()
            }
        }
    }
    
    func toggleLockedNumber(_ number: Int) {
        if lockedNumberInput == number {
            lockedNumberInput = nil
        } else {
            lockedNumberInput = number
        }
    }
    
    func inputLockedNumberIfNeeded() {
        guard let locked = lockedNumberInput else { return }
        
        guard let selected = selectedCell else { return }
        if grid[selected.row][selected.col].value == 0 {
            grid[selected.row][selected.col].value = locked
            checkWin()
        }
    }
    
    func removeDraftsAround(row: Int, col: Int) {
        let value = grid[row][col].value
        
        for r in 0..<9 {
            if grid[r][col].notes.contains(value) {
                grid[r][col].notes.remove(value)
            }
        }
        
        for c in 0..<9 {
            if grid[row][c].notes.contains(value) {
                grid[row][c].notes.remove(value)
            }
        }
        
        let startRow = (row / 3) * 3
        let startCol = (col / 3) * 3
        
        for r in startRow..<startRow+3 {
            for c in startCol..<startCol+3 {
                if grid[r][c].notes.contains(value) {
                    grid[r][c].notes.remove(value)
                }
            }
        }
    }
    
    
    private func convertToSaveGrid(from grid: [[Cell]]) -> [[SavedCell]] {
        grid.map { row in
            row.map { cell in
                SavedCell(
                    value: cell.value,
                    isOriginal: cell.isOriginal,
                    row: cell.row,
                    col: cell.col,
                    isIncorect: cell.isIncorrect,
                    notes: Array(cell.notes)
                )
            }
        }
    }
    
    private func isBoardFilled() -> Bool {
        for row in grid {
            for cell in row {
                if cell.value == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    private func isBoardCorrect() -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if grid[row][col].value != solutionGrid[row][col] {
                    return false
                }
            }
        }
        return true
    }
    
    private func checkWin() {
        if isBoardCorrect() && isBoardFilled() {
            finalTime = timer.elapsedTime
            timer.stop()
            isWon = true
            gameOver = true
            ProgressManager.shared.recordWin(for: level)
            StatisticsManager.shared.recordGame(won: true, flawless: mistakes == 0, time: finalTime, difficulty: level)
            GameSaveManager.shared.clearSavedGame()
        }
    }
    
    private func gameOverDueToMistakes() {
        timer.stop()
        isWon = false
        gameOver = true
        StatisticsManager.shared.recordGame(won: false, flawless: false, time: nil, difficulty: self.level)
        GameSaveManager.shared.clearSavedGame()
    }
    
    
    private func resetHintsIfNeeded() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        if lastHintResetDate != today {
            lastHintResetDate = today
            hintsUsedToday = 0
        }
    }
    private func updateHighlights(row: Int, col: Int) {
        highlightedCells = []
        
        let selectedValue = grid[row][col].value
        var duplicateCoords: [CellCoordinate] = []
        
//        let startRow = (row / 3) * 3
//        let startCol = (col / 3) * 3
//        for r in startRow..<startRow+3 {
//            for c in startCol..<startCol+3 {
//                highlightedCells.insert(CellCoordinate(row: r, col: c))
//            }
//        }

        // Подсвечиваем одинаковые цифры (только фон)
        if highlightsEnabled, selectedValue != 0 {
            for r in 0..<9 {
                for c in 0..<9 {
                    if grid[r][c].value == selectedValue {
                        duplicateCoords.append(CellCoordinate(row: r, col: c))
                    }
                }
            }
            // Просто выделяем блоки
            highlightedCells.formUnion(duplicateCoords)
        }

        // Если включен Highlight Lines (и премиум), то делаем линии
        if highlightLinesEnabled, isPremium, selectedValue != 0 {
            for dup in duplicateCoords {
                for i in 0..<9 {
                    highlightedCells.insert(CellCoordinate(row: dup.row, col: i))
                    highlightedCells.insert(CellCoordinate(row: i, col: dup.col))
                }
            }
        } else {
            // Стандартная линия только для выбранной клетки
//            for i in 0..<9 {
//                highlightedCells.insert(CellCoordinate(row: row, col: i))
//                highlightedCells.insert(CellCoordinate(row: i, col: col))
//            }
        }
    }
}
