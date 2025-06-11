
import SwiftUI

struct BottomSheetView: View {
    let trophy: Trophy?
    let onClose: () -> Void

    var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    if let trophy = trophy {
                        VStack(spacing: 20) {
                            Capsule()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 50, height: 6)
                                .padding(.top, 12)
                            Image(trophy.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .shadow(color: .purple, radius: 30)
                                .shadow(color: .white, radius: 60)
                            Text("\(trophy.level.rawValue.capitalized) – \(trophy.type.rawValue.capitalized) Trophy")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            Text("Win the \(trophy.level.rawValue.capitalized) level \(trophy.requiredWins) times to unlock this trophy.")
                                .multilineTextAlignment(.center)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.85))
                                .padding(.horizontal)
                            if trophy.isUnlocked {
                                Text("Trophy unlocked!")
                                    .foregroundColor(.green)
                                    .font(.headline)
                            } else {
                                Text("Progress: \(trophy.currentWins)/\(trophy.requiredWins)")
                                    .foregroundColor(.white.opacity(0.8))
                                    .font(.subheadline)
                            }
                            Button(action: onClose) {
                                Text("Close")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.purple)
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            .padding(.horizontal)
                        }
                        .background(
                            LinearGradient(colors: [.purple.opacity(0.5), .black], startPoint: .top, endPoint: .bottom)
                        )
                        .ignoresSafeArea()
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                .offset(y: trophy != nil ? 0 : geometry.size.height)
                .opacity(trophy != nil ? 1 : 0)
                .allowsHitTesting(trophy != nil)
            }
        }
    }


