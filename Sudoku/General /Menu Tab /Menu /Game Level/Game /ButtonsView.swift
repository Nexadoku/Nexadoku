
import SwiftUI

struct ButtonsView: View {
    var onNumberTap: (Int) -> Void = { _ in }
    var onEraseTap: () -> Void = {}
    var onPencilTap: () -> Void = {}
    var onHintTap: () -> Void = {}
    var usedNumbers: [Int: Int] = [:]
    var isPencilMode: Bool = false
    var gameOver: Bool = false
    
    @State private var remainingHints = 3

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 50) {
                actionButton(systemName: "eraser", action: {
                    if !gameOver { onEraseTap() }
                })
                actionButton(systemName: "pencil", action: onPencilTap)
                actionButton(systemName: "lightbulb", action: {
                    if remainingHints > 0 && !gameOver {
                        remainingHints -= 1
                        onHintTap()
                    }
                })
            }
            .overlay(alignment: .topTrailing) {
                if remainingHints > 0 {
                    Text("\(remainingHints)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.purple.opacity(0.8))
                        .clipShape(Circle())
                        .offset(x: 10, y: -10)
                }
            }
            
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { number in
                    numberButton(number: number)
                }
            }
            HStack(spacing: 12) {
                Spacer(minLength: 30)
                ForEach(6...9, id: \.self) { number in
                    numberButton(number: number)
                }
                Spacer(minLength: 30)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func numberButton(number: Int) -> some View {
        let isDisabled = usedNumbers[number, default: 0] >= 9

        if !isDisabled {
            let tapGesture = TapGesture()
                .onEnded {
                        onNumberTap(number)
                }

            Button {
               
            } label: {
                Text("\(number)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(isPencilMode ? .brown : .black)
                    .frame(width: 50, height: 50)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white, Color.white]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                        }
                    )
            }
            .simultaneousGesture(tapGesture)
            .buttonStyle(ScaleButtonStyle())
            .transition(.opacity.combined(with: .scale))
            .animation(.easeInOut(duration: 0.3), value: usedNumbers)
            .shadow(radius: 10)
        }
    }
    private func actionButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(LinearGradient(colors: [.white, .white], startPoint: .bottom, endPoint: .top))
                .shadow(color: Color.purple, radius: 20, x: 0, y: 0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

struct SudokuNumberPadPreviews: PreviewProvider {
    static var previews: some View {
        ButtonsView()
            .preferredColorScheme(.dark)
    }
}
