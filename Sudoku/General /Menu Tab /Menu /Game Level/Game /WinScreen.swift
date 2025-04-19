import SwiftUI

struct WinScreen: View {
    var onExit: () -> Void
    var timeElapsed: Int
    var mistakes: Int

    @State private var animateSparkle = false

    @AppStorage("mistakesEnabled") var mistakesEnabled: Bool = true
    @AppStorage("timerEnabled") var timerEnabled: Bool = true

    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        ZStack {
            SystemDarkBackground().blur(radius: 4)
                .ignoresSafeArea()

            VStack(spacing: 20) {

                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [.yellow.opacity(0.4), .clear]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 120
                            )
                        )
                        .scaleEffect(animateSparkle ? 1.2 : 0.8)
                        .blur(radius: 20)
                        .opacity(animateSparkle ? 1 : 0.6)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateSparkle)
                        .frame(width: 200, height: 200)

                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 140, height: 140)
                        .blur(radius: 30)

                    Image(systemName: "trophy.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundStyle(
                            LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom)
                        )
                        .shadow(color: .yellow, radius: 30)
                }
                    Text("Congratulations!")
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(.white)
                        .shadow(color: .purple, radius: 10)
                        .padding(.bottom, 10)
                    
                    // Капсула, только если хотя бы один активен
                    if mistakesEnabled || timerEnabled {
                        HStack(spacing: 0) {
                            if timerEnabled {
                                VStack {
                                    Text(timeFormatted(timeElapsed))
                                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                                        .foregroundColor(.green)
                                        .shadow(color: .black, radius: 1)
                                    Text("Time")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            
                            if timerEnabled && mistakesEnabled {
                                Divider()
                                    .frame(height: 70)
                                    .background(Color.black)
                            }
                            
                            if mistakesEnabled {
                                VStack {
                                    Text("Mistakes: \(mistakes)/3")
                                        .font(.system(size: 22, weight: .semibold))
                                        .foregroundColor(.red)
                                        .shadow(color: .black, radius: 1)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding()
                        .background(.purple)
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .shadow(color: .purple, radius: 15)
                        .padding(.horizontal)
                    }
                
                
                Button(action: onExit) {
                    Text("Return to Main Menu")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 30)
                        .background(.purple)
                        .cornerRadius(26)
                        .shadow(color: .purple, radius: 20)
                }
                .padding(.top, 20)
            }
        }
        .onAppear {
            animateSparkle = true
        }
    }
}
struct WinScreen_Previews: PreviewProvider {
    static var previews: some View {
        WinScreen(onExit: {}, timeElapsed: 123, mistakes: 1)
            .preferredColorScheme(.dark)
    }
}
