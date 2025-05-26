
import Foundation
import SwiftUI

enum  SudokuHighlight {
    case cell(row: Int, col: Int)
    case row(Int)
    case column(Int)
    case box(row: Int, col: Int)
}

struct DemoSudokuArrow {
    var from: ArrowTarget
    var to: ArrowTarget
}

enum ArrowTarget {
    case cell(row: Int, col: Int)
    case point(x: CGFloat, y: CGFloat)
}

struct DemoSudokuGrid: View {
    var highlights: [SudokuHighlight]
    var arrows: [DemoSudokuArrow]
    
    let cellSize: CGFloat = 40
    let gridPadding: CGFloat = 8
    let glowColor = Color.purple
    
    var body: some View {
        GeometryReader { geometry in
            let gridSize = cellSize * 9
            let offset = (geometry.size.width - gridSize) / 2
            
            ZStack {
                ForEach(0..<9, id: \.self) { row in
                    ForEach(0..<9, id: \.self) { col in
                        ZStack {
                            RoundedRectangle(cornerRadius: 0)
                                .fill(cellColor(row: row, col: col))
                                .frame(width: cellSize, height: cellSize)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(borderColor(row: row, col: col), lineWidth: 0.5)
                                )
                            Text(sampleGrid[row][col])
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .position(
                            x: offset + cellSize * CGFloat(col) + cellSize / 2,
                            y: offset + cellSize * CGFloat(row) + cellSize / 2
                        )
                    }
                }
                
                ForEach(0..<10) { i in
                    let lineOffset = CGFloat(i) * cellSize
                    Path { path in
                        path.move(to: CGPoint(x: offset + lineOffset, y: offset))
                        path.addLine(to: CGPoint(x: offset + lineOffset, y: offset + gridSize))
                    }
                    .stroke(i % 3 == 0 ? glowColor : glowColor.opacity(0.5), lineWidth: i % 3 == 0 ? 4 : 1)
                    
                    Path { path in
                        path.move(to: CGPoint(x: offset, y: offset + lineOffset))
                        path.addLine(to: CGPoint(x: offset + gridSize, y: offset + lineOffset))
                    }
                    .stroke(i % 3 == 0 ? glowColor : glowColor.opacity(0.5), lineWidth: i % 3 == 0 ? 4 : 1)
                }
                
                ForEach(0..<arrows.count, id: \.self) { idx in
                    DrawHelArrow(arrows: arrows[idx])
                }
            }
        }
        .frame(width: cellSize * 9 + 2 * 8, height: cellSize * 9 + 2 * 8)
    }
    
    let sampleGrid: [[String]] = [
        ["4","2","9","","","","8","","5","3"],
        ["8","7","6","","4","","3","","1","2"],
        ["","","","","9","7","","6","4",""],
        ["2","","6","1","","","","4","","7"],
        ["1","","7","","","","","","","9"],
        ["3","","5","","7","","2","","",""],
        ["","","","7","5","1","","3","","6"],
        ["1","","5","","8","6","","","",""],
        ["6","","3","","","","1","7","","5"]
    ]
    
    func cellColor(row: Int, col: Int) -> Color {
        if highlights.contains(where: { h in
            switch h {
            case .cell(let r, let c): return r == row && c == col
            case .row(let r): return r == row
            case .column(let c): return c == col
            case .box(let r, let c): return (row/3 == r/3 && col/3 == c/3)
                
            }
        }) {
            return Color.purple.opacity(0.35)
        }
        return Color.white.opacity(0.89)
    }
    
    func borderColor(row: Int, col: Int) -> Color {
        .purple.opacity(0.3)
    }
}

struct DrawHelArrow: View {
    var arrows: DemoSudokuArrow
    var body: some View {
        EmptyView()
    }
}

struct DemoSudokuGridPreviews: PreviewProvider {
    static var previews: some View {
        DemoSudokuGrid(
            highlights: [.cell(row: 1, col: 1)],
            arrows: []
        )
        .previewLayout(.sizeThatFits)
    }
}
