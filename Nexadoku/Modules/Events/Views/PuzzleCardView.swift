
import SwiftUI

struct PuzzleCardView: View {
    let title: String
    let description: String
    let image: String
    let action: () -> Void

    var body: some View {
        ZStack {
            
            // MARK: - IMAGE BACKGROUND (как в старом варианте)
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 250)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [.black.opacity(0.35), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(35)
            
            // MARK: - GLASS OVERLAY (новый стиль)
            RoundedRectangle(cornerRadius: 35, style: .continuous)
                .fill(Color.white.opacity(0.03))
                .background(
                    RoundedRectangle(cornerRadius: 35)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.18),
                                    Color(red: 60/255, green: 20/255, blue: 120/255).opacity(0.18)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.6),
                                    Color.white.opacity(0.15)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.25), radius: 14, x: 0, y: 8)
                .cornerRadius(35)
            
            // MARK: - CONTENT LAYOUT (как в старом варианте)
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(title)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.top, 15)
                        .padding(.horizontal, 20)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(Color.white.opacity(0.9))
                        .lineLimit(2)
                        .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // MARK: - BUTTON (новый градиент)
                Button(action: action) {
                    Text("Start")
                        .font(.title3)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 150/255, green: 80/255, blue: 255/255).opacity(0.9),
                                    Color(red: 90/255, green: 40/255, blue: 180/255).opacity(0.9)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(35)
                        .shadow(color: Color.purple.opacity(0.35), radius: 10, x: 0, y: 6)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 18)
            }
        }
        .frame(height: 250)
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.bottom)
    }
}

struct PuzzleCardView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleCardView(
            title: "Fast Math",
            description: "Solve complex math puzzles using logic.",
            image: "purpleCalculator"
        ) { }
            .preferredColorScheme(.dark)
    }
}
