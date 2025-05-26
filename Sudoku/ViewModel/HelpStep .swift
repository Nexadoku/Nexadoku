
import SwiftUI

struct HelpStep {
    let title: String
    let description: String
    let illustration: AnyView
    
    static let allSteps: [HelpStep] = [
        HelpStep(
            title: "What is Sudoku?",
            description: "Fill the entire 9x9 grid so that every row, every column, and every 3x3 box contains all digits from 1 to 9 with no repeats.",
            illustration: AnyView(
                DemoSudokuGrid(
                    highlights: [],
                    arrows: []
                )
            )
        ),
        HelpStep(
            title: "Select Cell",
            description: "Tap any empty cell to select it, The selected cell will be highlighted.",
            illustration: AnyView(
                DemoSudokuGrid(
                    highlights: [.cell(row: 0, col: 2)],
                    arrows: [.init(from: .point(x: 70, y: 40), to: .cell(row: 0, col: 2))]
                )
            )
        ),
        HelpStep(
            title: "Enter a Number",
            description: "Pick a number from the panel below to fill in the selected cell.",
            illustration: AnyView(
                DemoSudokuGrid(
                    highlights: [.cell(row: 0, col: 2)],
                    arrows: [.init(from: .point(x: 100, y: 320), to: .cell(row: 0, col: 2))]
                )
            )
        ),
        HelpStep(
            title: "No Duplicates Allowed",
            description: "The same number cannot repeat in any row, column, or 3x3 box.",
            illustration: AnyView(
                DemoSudokuGrid(
                    highlights: [
                        .row(0),
                        .column(1),
                        .box(row: 0, col: 0)
                    ],
                    arrows: []
                )
            )
        ),
        HelpStep(
            title: "Use the Eraser",
            description: "Erase mistakes or change your answer anytime using the eraser button.",
            illustration: AnyView(
                DemoSudokuGrid(
                    highlights: [.cell(row: 5, col: 6)],
                    arrows: [.init(from: .point(x: 60, y: 350), to: .cell(row: 5, col: 6))]
                )
            )
        ),
        HelpStep(
            title: "Pencil Mode",
            description: "In pencil mode, you can write possible candidates in a cell as small numbers.",
            illustration: AnyView(
                DemoSudokuGrid(
                    highlights: [.cell(row: 6, col: 2)],
                    arrows: [.init(from: .point(x: 210, y: 360), to: .cell(row: 6, col: 2))]
                )
            )
        ),
        HelpStep(
            title: "Hints",
            description: "Need help? Tap the hint button (lightvulb). The number of hints is limited",
            illustration: AnyView(
                DemoSudokuGrid(
                    highlights: [],
                    arrows: [.init(from: .point(x: 320, y: 350), to: .point(x: 330, y: 60))]
                )
            )
        ),
        HelpStep(
            title: "Mistakes",
            description: "You can make up to 3 mistakes per game. After that, the game ends!",
            illustration: AnyView(
                DemoSudokuGrid(
                    highlights: [],
                    arrows: [.init(from: .point(x: 180, y: 15), to: .point(x: 180, y: 35))]
                )
            )
        )
    ]
}
