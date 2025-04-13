import SwiftUI

struct CellView: View {
    let cell: Cell
    let isSelected: Bool
    let isHighlighted: Bool
    let onTap: () -> Void
    
    private var drawsGradient: Bool {
        !(cell.isIncorrect || isSelected || isHighlighted)
    }

    var body: some View {
        ZStack {
            backgroundColor
                .frame(width: 40, height: 40)
                .cornerRadius(1)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black.opacity(0.2), lineWidth: 0.5))

            if drawsGradient {
                Rectangle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white,
                                Color.purple.opacity(0.5),
                                Color.indigo.opacity(0.6)
                            ]),
                            center: .center,
                            startRadius: 5,
                            endRadius: 80
                        )
                    )
                    .frame(width: 40, height: 40)
                    .cornerRadius(1)
            }
            
            if cell.value != 0 {
                Text("\(cell.value)")
                    .foregroundColor(cell.isIncorrect ? .red : cell.isOriginal ? .black : isSelected ? .white : .indigo)
                    .font(.system(size: 20, weight: .bold))
            } else if !cell.notes.isEmpty {
                notesGrid
            }
        }
        .onTapGesture {
            onTap()
        }
    }

    private var backgroundColor: Color {
        if cell.isIncorrect {
            return Color.red.opacity(0.15)
        } else if isSelected {
            return Color.indigo
        } else if isHighlighted {
            return Color.purple.opacity(0.3)
        } else {
            return Color.white
        }
    }

    private var notesGrid: some View {
        let rows = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ]

        return VStack(spacing: 0) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(row, id: \.self) { number in
                        Text(cell.notes.contains(number) ? "\(number)" : " ")
                            .font(.caption2)
                            .foregroundColor(.black)
                            .frame(width: 12, height: 12)
                    }
                }
            }
        }
    }
}

