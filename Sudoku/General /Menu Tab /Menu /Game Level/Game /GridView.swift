import SwiftUI

struct GridView: View {
    @ObservedObject var game: Game
    
    let cellSize: CGFloat = 40
    let lineWidth: CGFloat = 2
    let glowColor = Color.purple
    
    var body: some View {
        GeometryReader { geometry in
            let gridSize = cellSize * 9
            let offset = (geometry.size.width - gridSize) / 2
            
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                    .shadow(color: .purple, radius: 10)
                
                ForEach(0..<9, id: \.self) { row in
                    ForEach(0..<9, id: \.self) { col in
                        CellView(
                            cell: game.grid[row][col],
                            isSelected: game.isSelected(row: row, col: col),
                            isHighlighted: game.isHighlighted(row: row, col: col)
                            
                        ) {
                            game.selectCell(row: row, col: col)
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
            }
        }
        .frame(width: cellSize * 9, height: cellSize * 9)
    }
}

struct GridViewPreviews: PreviewProvider {
    static var previews: some View {
        GridView(game: Game(level: .easy))
    }
}
