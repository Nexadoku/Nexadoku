//
//  Generator.swift
//  SUDOKU
//
//  Created by Helter Skelter on 22/04/25.
//

import Foundation


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

