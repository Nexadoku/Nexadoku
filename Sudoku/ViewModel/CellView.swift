import SwiftUI

struct CellView: View {
    let cell: Cell
    let isSelected: Bool
    let isHighlighted: Bool
    let completedNumber: Int?
    let onTap: () -> Void
    @AppStorage("mistakesEnabled") private var mistakesEnabled: Bool = true
    @State private var pulse = false
    
    private var drawsGradient: Bool {
        !(cell.isIncorrect || isSelected || isHighlighted)
    }

    var body: some View {
        ZStack {
            backgroundColor
                .frame(width: 40, height: 40)
                .cornerRadius(1)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black.opacity(0.2), lineWidth: 0.5))
                .animation(.easeInOut(duration: 1), value: shouldAnimate)
                

            if drawsGradient {
                Rectangle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.5),
                                Color.indigo
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
                    .foregroundColor(mistakesEnabled && cell.isIncorrect ? .red : cell.isOriginal ? .black : isSelected ? .white : .indigo)
                    .font(.system(size: 20, weight: .bold))
            } else if !cell.notes.isEmpty {
                notesGrid
            }
        }
        .onTapGesture {
            onTap()
            SoundManager.shared.playSound(named: "SelectCell")
            VibrationManager.shared.lightImpact()
        }
    }
    
    private var shouldAnimate: Bool {
        isHighlighted && completedNumber == cell.value && cell.value != 0
    }

    private var backgroundColor: Color {
        if mistakesEnabled && cell.isIncorrect {
            return Color.red.opacity(0.15)
        } else if isSelected {
            return Color.indigo
        } else if isHighlighted {
            return Color.purple.opacity(0.7)
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
