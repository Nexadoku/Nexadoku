
import SwiftUI

struct HelpStep: Identifiable {
    let id = UUID()
    let title: String
    let topImage: AnyView?
    let topText: String?
    let bottomText: String?
    
    static let allSteps: [HelpStep] = [
        // 1. Introduction
        HelpStep(
            title: "What is Sudoku?",
            topImage: nil,
            topText: """
Sudoku is a classic logic puzzle played on a 9x9 grid, divided into nine 3x3 boxes. Your goal is to fill every cell with a digit from 1 to 9. The rules are simple, but the challenge is fun and addictive!
""",
            bottomText: """
Each row, each column, and each 3x3 box must contain every number from 1 to 9, without any repeats. You don't need to guess—every Sudoku can be solved by logic alone!
"""
        ),
        // 2. Selecting a Cell
        HelpStep(
            title: "Selecting a Cell",
            topImage: nil,
            topText: """
Tap any empty cell to select it. The selected cell will be highlighted, showing you where your next move will go.
""",
            bottomText: """
Selecting a cell is the first step to entering a number or making a note. Make sure the correct cell is selected before continuing.
"""
        ),
        // 3. Entering a Number
        HelpStep(
            title: "Entering a Number",
            topImage: AnyView(
                Button(action: {}) {
                    Text("5")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                        .shadow(radius: 8)
                }
            ),
            topText: """
To place a number, simply tap a digit on the number pad below the grid. The number will appear in the currently selected cell.
""",
            bottomText: """
Be careful: you can’t put the same number twice in any row, column, or 3x3 box. If you make a mistake, the cell will let you know!
"""
        ),
        // 4. No Duplicates Allowed
        HelpStep(
            title: "No Duplicates Allowed",
            topImage: nil,
            topText: """
Sudoku is all about logic and uniqueness. Each number from 1 to 9 should appear exactly once in every row, every column, and every 3x3 box.
""",
            bottomText: """
If you try to place a duplicate, the app will highlight the cell in red to warn you about the mistake. Use this to quickly spot errors and keep your puzzle on track.
"""
        ),
        // 5. Erase Button
        HelpStep(
            title: "Erasing Mistakes",
            topImage: AnyView(
                Image(systemName: "eraser")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.purple)
                    .shadow(radius: 12)
            ),
            topText: """
If you want to remove a number or clear a note, tap the eraser button and then tap the cell you want to erase. This helps you fix mistakes without starting over.
""",
            bottomText: """
Don't worry if you enter a wrong number! Use the eraser to quickly clean up and try again. Making corrections is part of the learning process.
"""
        ),
        // 6. Pencil Mode
        HelpStep(
            title: "Pencil Mode",
            topImage: AnyView(
                Image(systemName: "pencil")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.purple)
                    .shadow(radius: 12)
            ),
            topText: """
Not sure what number goes in a cell? Tap the pencil button to enter 'pencil mode'. Now, when you tap a number, it will appear as a small note instead of a big answer.
""",
            bottomText: """
Pencil marks let you jot down possible candidates. Use this feature to keep track of options—it's a powerful tool for solving tricky puzzles step by step!
"""
        ),
        // 7. Hints Button
        HelpStep(
            title: "Hints",
            topImage: AnyView(
                Image(systemName: "lightbulb")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.yellow)
                    .shadow(radius: 12)
            ),
            topText: """
Feeling stuck? Tap the hint button (the lightbulb icon). The app will automatically fill in a correct number for you.
""",
            bottomText: """
Remember, hints are limited—so use them wisely! Hints are great when you want to learn or just keep the game moving forward.
"""
        ),
        // 8. Mistake Limit
        HelpStep(
            title: "Mistake Limit",
            topImage: nil,
            topText: """
To keep Sudoku challenging, you can only make up to 3 mistakes per game. If you reach the limit, the game will end.
""",
            bottomText: """
Try to solve each puzzle with as few mistakes as possible. Use logic, pencil marks, and the eraser to help you win!
"""
        )
    ]
}
