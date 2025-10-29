
import SwiftUI

struct BottomSheetView: View {
    let trophy: Trophy?
    let onClose: () -> Void

    @State private var appear = false

    var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    if let trophy = trophy {
                        VStack(spacing: 20) {
                            Capsule()
                                .fill(Color.white.opacity(0.28))
                                .frame(width: 60, height: 6)
                                .padding(.top, 14)

                            Image(trophy.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .shadow(color: .black.opacity(0.28), radius: 16, x: 0, y: 10)

                            Text("\(trophy.level.rawValue.capitalized) – \(trophy.type.rawValue.capitalized) Trophy")
                                .font(.system(size: 24, weight: .heavy))
                                .foregroundColor(.white)

                            Text("Win the \(trophy.level.rawValue.capitalized) level \(trophy.requiredWins) times to unlock this trophy.")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 17))
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.horizontal)

                            Text("Progress: \(trophy.currentWins)/\(trophy.requiredWins)")
                                .foregroundColor(.white.opacity(0.9))
                                .font(.system(size: 16, weight: .semibold))

                            Button(action: onClose) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .fill(LinearGradient(colors: [Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.16), Color.white.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                                }
                                .frame(height: 60)
                                .overlay(
                                    Text("Close")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.white)
                                )
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                        }
                        .padding(.bottom, geometry.safeAreaInsets.bottom == 0 ? 18 : geometry.safeAreaInsets.bottom)
                        .background(glassBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
                        .padding(.horizontal, 10)
                        .scaleEffect(appear ? 1 : 0.98)
                        .animation(.spring(response: 0.45, dampingFraction: 0.9), value: appear)
                        .onAppear { appear = true }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                .offset(y: trophy != nil ? 0 : geometry.size.height)
                .opacity(trophy != nil ? 1 : 0)
                .allowsHitTesting(trophy != nil)
                .animation(.spring(response: 0.5, dampingFraction: 0.88), value: trophy != nil)
            }
        }
    }

    private var glassBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.42),
                            Color(red: 60/255, green: 20/255, blue: 120/255).opacity(0.42)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.22), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
                .blendMode(.screen)
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.85), Color.white.opacity(0.25)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .stroke(Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.35), lineWidth: 0.6)
                .blur(radius: 2)
                .offset(x: -1, y: -1)
                .opacity(0.6)
        }
        .shadow(color: .black.opacity(0.35), radius: 24, x: 0, y: 18)
        .shadow(color: .white.opacity(0.06), radius: 8, x: -2, y: -2)
    }


