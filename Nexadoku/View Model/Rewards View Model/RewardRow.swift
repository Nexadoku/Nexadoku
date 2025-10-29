
import SwiftUI

struct RewardRow: View {
    let trophy: Trophy
    let claimed: Bool
    let onClaim: () -> Void
    var onTap: () -> Void

    var body: some View {
        ZStack {
            glassBackground
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .center, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(trophy.level.rawValue.capitalized) – \(trophy.type.rawValue.capitalized) Trophy")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(.white)
                        if trophy.isUnlocked {
                            Text("Unlocked!")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.green)
                        } else {
                            Text("Win \(max(trophy.requiredWins - trophy.currentWins, 0)) more time(s) to unlock")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white.opacity(0.75))
                        }
                    }
                    Spacer()
                    VStack(spacing: 6) {
                        Image(trophy.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 72)
                            .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                    }
                    .onTapGesture { onTap() }
                }

                ProgressBar(current: trophy.currentWins, total: trophy.requiredWins)
                    .frame(height: 10)
                    .padding(.horizontal, 2)

                Button(action: {
                    if trophy.isUnlocked && !claimed { onClaim() }
                }) {
                    HStack {
                        Spacer()
                        if claimed {
                            Text("Claimed").font(.system(size: 16, weight: .bold))
                        } else if trophy.isUnlocked {
                            Text("Claim").font(.system(size: 16, weight: .bold))
                        } else {
                            Text("Locked").font(.system(size: 16, weight: .bold))
                        }
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .background(glassButtonBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .disabled(!trophy.isUnlocked || claimed)
            }
            .padding(18)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 150)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 8)
        .shadow(color: .white.opacity(0.06), radius: 4, x: -1, y: -1)
    }
    
    private var glassBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.42),
                            Color(red: 60/255, green: 20/255, blue: 120/255).opacity(0.32)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.22), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
                .blendMode(.screen)
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.8), Color.white.opacity(0.25)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
    }

    private var glassButtonBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.18),
                            Color.white.opacity(0.06)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.35), lineWidth: 1)
        }
    }
}
