
import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    
    var currentBackgroundColor: some View {
        SystemDarkBackground()
    }
    
    var body: some View {
            ZStack {
                currentBackgroundColor
                    .ignoresSafeArea()
                
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        title: " SUDOKU",
                        subtitle: "Твоя ежедневная головоломка для ума",
                        color: .clear,
                        imageName: "brain.head.profile",
                        textColor: .white
                    ).tag(0)
                    
                    OnboardingPageView(
                        title: "Премиальный дизайн",
                        subtitle: "Фиолетовые акценты, тёмная эстетика",
                        color: .clear,
                        imageName: "sparkles",
                        textColor: .white
                    ).tag(1)
                    
                    OnboardingPageView(
                        title: "Готов начать?",
                        subtitle: "Нажми и начни игру прямо сейчас",
                        color: .clear,
                        imageName: "checkmark.seal",
                        textColor: .white,
                        showButton: true,
                        buttonAction: {
                            withAnimation {
                                hasSeenOnboarding = true
                            }
                        }
                    ).tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .animation(.easeInOut(duration: 0.4), value: currentPage)
            }
        }
    }


struct OnboardingPageView: View {
    let title: String
    let subtitle: String
    let color: Color
    let imageName: String
    let textColor: Color
    var showButton: Bool = false
    var buttonAction: (() -> Void)? = nil

    var body: some View {
        ZStack {
            color
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(textColor)

                VStack(spacing: 12) {
                    Text(title)
                        .font(.largeTitle.bold())
                        .foregroundColor(textColor)
                        .multilineTextAlignment(.center)

                    Text(subtitle)
                        .font(.title3)
                        .foregroundColor(textColor.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                if showButton, let action = buttonAction {
                    Button(action: action) {
                        Text("Начать")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(16)
                            .padding(.horizontal, 32)
                    }
                    .padding(.top, 40)
                }

                Spacer()
            }
            .padding()
        }
    }
    
    private func background(_ color: Color) -> LinearGradient {
        LinearGradient(colors: [.black, Color(hue: 0.75, saturation: 0.5, brightness: 0.2),], startPoint: .top, endPoint: .bottom)
        }
    }


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

