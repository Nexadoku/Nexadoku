
import SwiftUI

struct GridView: View {
    @ObservedObject var game: Game

    let cellSize: CGFloat = 40
    let lineWidth: CGFloat = 2
    let glowColor = (Color(red: 140/255, green: 60/255, blue: 255/255))

    var body: some View {
        GeometryReader { geometry in
            let gridSize = cellSize * 9
            let offset = (geometry.size.width - gridSize) / 2

            ZStack {
                
                ForEach(0..<9, id: \.self) { row in
                    ForEach(0..<9, id: \.self) { col in
                        CellView(
                            cell: game.grid[row][col],
                            isSelected: game.isSelected(row: row, col: col),
                            isHighlighted: game.isHighlighted(row: row, col: col),
                            completedNumber: game.completedNumbers,
                            onTap: { game.selectCell(row: row, col: col) }
                                                      
                     
                        )
                        .position(
                            x: offset + cellSize * CGFloat(col) + cellSize / 2,
                            y: offset + cellSize * CGFloat(row) + cellSize / 2
                        )
                    }
                }

                ForEach(0..<10) { i in
                    let lineOffset = CGFloat(i) * cellSize

                    // Вертикальные тонкие линии
                    Path { path in
                        path.move(to: CGPoint(x: offset + lineOffset, y: offset))
                        path.addLine(to: CGPoint(x: offset + lineOffset, y: offset + gridSize))
                    }
                    .stroke(glowColor.opacity(0.5), lineWidth: 1)

                    // Горизонтальные тонкие линии
                    Path { path in
                        path.move(to: CGPoint(x: offset, y: offset + lineOffset))
                        path.addLine(to: CGPoint(x: offset + gridSize, y: offset + lineOffset))
                    }
                    .stroke(glowColor.opacity(0.5), lineWidth: 1)
                }

                // Толстые линии только внутри (на 3 и 6), НЕ на 0 и 9!
                ForEach([3, 6], id: \.self) { i in
                    let thickOffset = CGFloat(i) * cellSize

                    // Вертикальные толстые линии
                    Path { path in
                        path.move(to: CGPoint(x: offset + thickOffset, y: offset))
                        path.addLine(to: CGPoint(x: offset + thickOffset, y: offset + gridSize))
                    }
                    .stroke(glowColor, lineWidth: 2)

                    // Горизонтальные толстые линии
                    Path { path in
                        path.move(to: CGPoint(x: offset, y: offset + thickOffset))
                        path.addLine(to: CGPoint(x: offset + gridSize, y: offset + thickOffset))
                    }
                    .stroke(glowColor, lineWidth: 2)
                }

                // Рамка по краю, чтобы не было двойных толстых линий
                Path { path in
                    path.addRect(CGRect(x: offset, y: offset, width: gridSize, height: gridSize))
                }
                .stroke(glowColor, lineWidth: 2)
            }
        }
        .frame(width: cellSize * 9, height: cellSize * 9)
    }
}

struct GridViewPreviews: PreviewProvider {
    static var previews: some View {
        GridView(game: Game(state: .new(level: .medium)))
    }
}
