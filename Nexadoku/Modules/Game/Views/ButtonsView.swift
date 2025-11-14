
import SwiftUI

struct ButtonsView: View {
    var onNumberTap: (Int) -> Void = { _ in }
    var onEraseTap: () -> Void = {}
    var onPencilTap: () -> Void = {}
    var onHintTap: () -> Void = {}
    var usedNumbers: [Int: Int] = [:]
    var isPencilMode: Bool = false
    var gameOver: Bool = false
    var remainingHints = 3

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 50) {
                actionButton(systemName: "eraser", action: {
                    if !gameOver { onEraseTap() }
                })
                actionButton(systemName: "pencil", action: onPencilTap)
                actionButton(systemName: "lightbulb", action: {
                    if remainingHints > 0 && !gameOver {
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
                        .background((Color(red: 140/255, green: 60/255, blue: 255/255)).opacity(0.5))
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
    
        
        ZStack {
            if isDisabled {
                Color.clear
                    .frame(width: 50, height: 50)
            } else {
                let tapGesture = TapGesture()
                    .onEnded {
                        onNumberTap(number)
                    }
                
                Button {
                    
                } label: {
                    Text("\(number)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(isPencilMode ? .indigo : .black)
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
                                
                                if isDisabled {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.8), lineWidth: 5)
                                        .scaleEffect(1.2)
                                        .opacity(0)
                                        .animation(
                                            .easeOut(duration: 0.4),
                                            value: isDisabled
                                        )
                                }
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.8), lineWidth: 1)
                            }
                        )
                }
                .simultaneousGesture(tapGesture)
                .buttonStyle(ScaleButtonStyle())
                .shadow(radius: 10)
                .transition(
                    .asymmetric(
                        insertion: .identity,
                        removal: .scale(scale: 0.5).combined(with: .opacity)
                    )
                )
            }
        }
        .frame(width: 50, height: 50)
        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isDisabled)
    }
    private func actionButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(LinearGradient(colors: [.white, .white], startPoint: .bottom, endPoint: .top))
                .shadow(color: Color.white, radius: 10, x: 0, y: 0)
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

