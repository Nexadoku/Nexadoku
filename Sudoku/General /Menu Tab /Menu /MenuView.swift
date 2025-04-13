
import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var navigator: Navigator
    
    var body: some View {
        ZStack {
            LuxuriousDarkBackgroundView()
            VStack(spacing: 30) {
                Text("SUDOKU")
                    .font(.system(size: 50, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    .shadow(radius: 20)
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(50)
                    .frame(width: 150, height: 150)
                    .shadow(color: .indigo, radius: 10)
                    .shadow(color: .purple, radius: 10)
                
                Spacer()
                
                VStack(spacing: 20) {
                    neonButton(title: "Play Sudoku", icon: "gamecontroller.fill") {
                        navigator.push(.menu(.levelSelection))
                    }
                    
                    neonButton(title: "Trials", icon: "brain.head.profile.fill") {
                        navigator.push(.menu(.events))
                    }
                }
                Spacer()
            }
            .padding(.bottom)
        }
    }
    
    func neonButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack {
                    Image(systemName: icon)
                        .font(.title2)
                    Text(title)
                        .font(.title2.bold())
                }
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: 500, maxHeight: 60)
                .background(.white)
                .cornerRadius(25)
                .shadow(radius: 20)
            }
            .padding(.horizontal)
        }
}

struct MenuViewPreviews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .preferredColorScheme(.dark)
    }
}
