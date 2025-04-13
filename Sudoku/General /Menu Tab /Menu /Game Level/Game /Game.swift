import Foundation
import SwiftUI
import Combine

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
    
    var level: DifficultyLevel
    private var solutionGrid: [[Int]] = []
    private var timerCancellable: AnyCancellable?
    
    init(level: DifficultyLevel) {
        self.level = level
        self.timer = GameTimer()
    }
    
    deinit {
        timer.stop()
    }
    
    func loadGame() async {
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        await generateSudokuGrid()
        startTimer()
    }
    
    func startTimer() {
        timer.start()
    }
    
    func togglePencilMode() {
        pencilMode.toggle()
    }
    
    func useHint() {
        guard remainingHints > 0 else { return }
        guard let selected = selectedCell else { return }
        guard !grid[selected.row][selected.col].isOriginal else { return }
        
        let correctValue = solutionGrid[selected.row][selected.col]
        grid[selected.row][selected.col].value = correctValue
        grid[selected.row][selected.col].notes = []
        remainingHints -= 1
    }
    
    func restart() {
        mistakes = 0
        gameOver = false
        isWon = false
        selectedCell = nil
        highlightedCells = []
        timer.reset()
        timer.start()
        lockedNumberInput = nil
        remainingHints = 3
        Task { await generateSudokuGrid() }
    }
    
    func restartCurrentGameState() {
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
        remainingHints = 3
        selectedCell = nil
        highlightedCells = []
        isWon = false
        gameOver = false
        lockedNumberInput = nil
        timer.reset()
        timer.start()
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
            StatsManager.shared.recordGame(won: true, flawless: mistakes == 0, time: finalTime)
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
            removeDraftsAround(row: selected.row, col: selected.col)
            checkWin()
        } else {
            grid[selected.row][selected.col].value = value
            grid[selected.row][selected.col].isIncorrect = true   // <--- добавлено
            mistakes += 1
            if mistakes >= 3 {
                isWon = false
                gameOver = true
            }
        }
        
        if let lockedNumber = lockedNumberInput, grid[selected.row][selected.col].value != lockedNumber {
            grid[selected.row][selected.col].value = lockedNumber
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
    
    private func updateHighlights(row: Int, col: Int) {
        highlightedCells = []
        let selectedValue = grid[row][col].value
        
        for i in 0..<9 {
            highlightedCells.insert(CellCoordinate(row: row, col: i))
            highlightedCells.insert(CellCoordinate(row: i, col: col))
        }
        
        if selectedValue != 0 {
            for r in 0..<9 {
                for c in 0..<9 {
                    if grid[r][c].value == selectedValue {
                        highlightedCells.insert(CellCoordinate(row: r, col: c))
                    }
                }
            }
        }
    }
}


struct Cell: Identifiable, Hashable, Codable {
    var id = UUID()
    var value: Int
    var isOriginal: Bool
    var row: Int
    var col: Int
    var isIncorrect: Bool = false
    var notes: Set<Int> = []
}

struct CellCoordinate: Hashable {
    let row: Int
    let col: Int
}

struct SudokuGenerator {
    static func generateSolvedGrid() -> [[Int]] {
        var grid = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        fillGrid(&grid)
        return grid
    }
    
    @discardableResult
    static func fillGrid(_ grid: inout [[Int]]) -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if grid[row][col] == 0 {
                    let numbers = Array(1...9).shuffled()
                    for num in numbers {
                        if isSafe(grid, row, col, num) {
                            grid[row][col] = num
                            if fillGrid(&grid) {
                                return true
                            }
                            grid[row][col] = 0
                        }
                    }
                    return false
                }
            }
        }
        return true
    }
    
    static func isSafe(_ grid: [[Int]], _ row: Int, _ col: Int, _ num: Int) -> Bool {
        for i in 0..<9 {
            if grid[row][i] == num || grid[i][col] == num {
                return false
            }
        }
        let startRow = (row / 3) * 3
        let startCol = (col / 3) * 3
        for i in 0..<3 {
            for j in 0..<3 {
                if grid[startRow + i][startCol + j] == num {
                    return false
                }
            }
        }
        return true
    }
    
    static func removeNumbers(from solved: [[Int]], clues: Int) -> [[Cell]] {
        var grid = solved
        var positions = (0..<9).flatMap { row in (0..<9).map { col in (row, col) } }
        positions.shuffle()
        
        // Подсчёт количества каждой цифры
        var numberCounts: [Int: Int] = [:]
        for row in 0..<9 {
            for col in 0..<9 {
                let value = grid[row][col]
                numberCounts[value, default: 0] += 1
            }
        }
        
        var cellsToRemove = 81 - clues
        
        for (row, col) in positions {
            guard cellsToRemove > 0 else { break }
            
            let currentValue = grid[row][col]
            if currentValue != 0, numberCounts[currentValue, default: 0] > 1 {
                grid[row][col] = 0
                numberCounts[currentValue, default: 0] -= 1
                cellsToRemove -= 1
            }
        }
        
        // Убираем лишние цифры, если их больше 7
        for number in 1...9 {
            while numberCounts[number, default: 0] > 7 {
                for (row, col) in positions {
                    if grid[row][col] == number {
                        grid[row][col] = 0
                        numberCounts[number, default: 0] -= 1
                        break
                    }
                }
            }
        }
        
        return grid.enumerated().map { (r, row) in
            row.enumerated().map { (c, value) in
                Cell(value: value, isOriginal: value != 0, row: r, col: c)
            }
        }
    }
    
}


final class GameTimer: ObservableObject {
    @Published private(set) var elapsedTime: Int = 0
    
    private var timer: Timer?
    private var startDate: Date?
    private var accumulatedTime: Int = 0
    
    func start() {
        guard timer == nil else { return }
        
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            handleTimer()
        }
    }
    
    func stop() {
        if let start = startDate {
            accumulatedTime += Int(Date().timeIntervalSince(start))
        }
        
        timer?.invalidate()
        timer = nil
        startDate = nil
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        startDate = nil
        accumulatedTime = 0
        elapsedTime = 0
    }
    
    private func handleTimer() {
        guard let start = startDate else { return }
        elapsedTime = accumulatedTime + Int(Date().timeIntervalSince(start))
    }
}
