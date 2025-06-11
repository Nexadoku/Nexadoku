
import SwiftUI

struct RewardRow: View {
    let trophy: Trophy
    let claimed: Bool
    let onClaim: () -> Void
    var onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(trophy.level.rawValue.capitalized) – \(trophy.type.rawValue.capitalized) Trophy")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    if trophy.isUnlocked {
                        Text("Unlocked!")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.green)
                    } else {
                        Text("Win \(max(trophy.requiredWins - trophy.currentWins, 0)) more time(s) to unlock")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white.opacity(0.68))
                    }
                }
                Spacer()
                ZStack {
                    Image(trophy.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 54, height: 54)
                }
                .onTapGesture { onTap() }
            }
            
            ProgressBar(current: trophy.currentWins, total: trophy.requiredWins)
                .frame(height: 8)
                .padding(.horizontal, 2)
                .padding(.bottom, 2)
                .shadow(radius: 20)
            
            Button(action: {
                if trophy.isUnlocked && !claimed {
                    onClaim()
                }
            }) {
                HStack {
                    Spacer()
                    if claimed {
                        Text("Claimed")
                            .font(.system(size: 15, weight: .bold))
                    } else if trophy.isUnlocked {
                        Text("Claim")
                            .font(.system(size: 15, weight: .bold))
                    } else {
                        Text("Locked")
                            .font(.system(size: 15, weight: .bold))
                    }
                    Spacer()
                }
                .foregroundColor(buttonTextColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(buttonBackground)
                .cornerRadius(15)
                .shadow(color: .purple.opacity(trophy.isUnlocked && !claimed ? 0.28 : 0), radius: 5)
                .shadow(radius: 20)
            }
            .disabled(!trophy.isUnlocked || claimed)
        }
        .padding(16)
        .background(
            LinearGradient(colors: [Color.purple.opacity(0.5), Color.black], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .purple.opacity(0.18), radius: 12, x: 0, y: 6)
    }
    
    private var buttonBackground: some View {
        Group {
            if claimed {
                Color.gray
            } else if trophy.isUnlocked {
                Color.green
            } else {
                Color.purple
            }
        }
    }
    
    private var buttonTextColor: Color {
        if claimed || !trophy.isUnlocked {
            return .white
        } else {
            return .white
        }
    }
}
