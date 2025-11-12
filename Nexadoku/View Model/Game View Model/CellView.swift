
import SwiftUI

struct CellView: View {
    let cell: Cell
    let isSelected: Bool
    let isHighlighted: Bool
    let completedNumber: Int?
    let onTap: () -> Void

    @AppStorage("mistakesEnabled") private var mistakesEnabled: Bool = true
    @State private var animateCells = false
    @State private var glow = false
    @State private var lastAnimationID = 0

    private var drawsGradient: Bool {
        !(cell.isIncorrect || isSelected || isHighlighted)
    }

    var body: some View {
        ZStack {
            backgroundColor
                .frame(width: 40, height: 40)
                .cornerRadius(1)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black.opacity(0.7), lineWidth: 0.5))
                .animation(.easeInOut(duration: 1), value: shouldAnimate)

           

            if cell.value != 0 {
                Text("\(cell.value)")
                    .foregroundStyle(
                        mistakesEnabled && cell.isIncorrect
                        ? LinearGradient(colors: [.red], startPoint: .top, endPoint: .bottom)
                            : cell.isOriginal
                        ? LinearGradient(colors: [.white], startPoint: .top, endPoint: .bottom)
                                : isSelected
                                    ? LinearGradient(colors: [.white], startPoint: .top, endPoint: .bottom)
                                    : LinearGradient(
                                        colors: [.white, .teal],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                    )
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
            return Color.indigo.opacity(0.4)
        } else if isHighlighted {
            return (Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.4))
        } else {
            return Color.black.opacity(0.4)
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
                            .foregroundColor(.white)
                            .frame(width: 12, height: 12)
                    }
                }
            }
        }
    }
}
