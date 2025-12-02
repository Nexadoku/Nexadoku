
import SwiftUI

struct EventCardView: View {
    let title: String
    let description: String
    let image: String
    let action: () -> Void

    var body: some View {
        ZStack {
            // Background image
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 220)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.05),
                            Color.black.opacity(0.45)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    LinearGradient(
                        colors: [
                            Color.purple.opacity(0.25),
                            Color.indigo.opacity(0.2),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(28)

            // Glass overlay
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white.opacity(0.04))
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.53, green: 0.13, blue: 0.92).opacity(0.22),
                                    Color(red: 0.21, green: 0.06, blue: 0.40).opacity(0.22)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.45),
                                    Color.white.opacity(0.15)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.1
                        )
                )
                .shadow(color: .black.opacity(0.45), radius: 20, x: 0, y: 10)

            VStack(alignment: .leading, spacing: 10) {
                Spacer()

                Text(title)
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundColor(.white)
                    .shadow(radius: 10)

                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(2)

                Button(action: action) {
                    Text("Start")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color.purple.opacity(0.9),
                                    Color.indigo.opacity(0.9)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .shadow(color: .purple.opacity(0.35), radius: 12, x: 0, y: 6)
                }
                .padding(.top, 8)
            }
            .padding(22)
        }
        .frame(height: 220)
        .padding(.horizontal)
        .padding(.bottom)
    }
}
