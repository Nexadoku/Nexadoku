
import SwiftUI

struct MathPuzzleView: View {
    @ObservedObject var game = MathPuzzleGame()
    @Environment(\.dismiss) var dismiss
    @State private var bounce = false
    
    var body: some View {
        ZStack {
            SystemBackground()
            
            VStack {
                // HEADER
                HStack {
                    Button {
                        dismiss()
                        VibrationManager.shared.lightImpact()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .heavy))
                            .shadow(radius: 10)
                    }
                    
                    Text("FAST MATH")
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundColor(.white)
                        .shadow(radius: 10)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                Spacer()
                
                // GAME OVER SCREEN
                if game.gameOver {
                    VStack {
                        Text(game.score <= 20 ? "You Lose!" : "You Win!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                        
                        Text("Score: \(game.score)")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                        
                        Text("Best Score: \(game.highScore)")
                            .font(.title2)
                            .foregroundColor(.yellow)
                            .padding(.bottom, 10)
                        
                        Button(action: {
                            game.restartGame()
                            VibrationManager.shared.lightImpact()
                        }) {
                            Text("Restart Game")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color(red: 140/255, green: 60/255, blue: 255/255))
                                .cornerRadius(20)
                        }
                    }
                }
                else {
                    // CALCULATOR IMAGE
                    Image("purpleCalculator")
                        .resizable()
                        .frame(width: 200, height: 250)
                        .offset(y: bounce ? -10 : 0)
                        .scaleEffect(bounce ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.25), value: bounce)
                        .shadow(color: Color(red: 140/255, green: 60/255, blue: 255/255), radius: 10)
                    
                    // SCORE
                    Text("Score: \(game.score)")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    // CURRENT QUESTION
                    Text(game.currentQuestion.question)
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: game.questionIndexCategory)
                    
                    // OPTIONS
                    VStack(spacing: 15) {
                        ForEach(game.currentOption, id: \.self) { option in
                            Button(action: {
                                
                                if option == game.currentQuestion.answer {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        bounce = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            bounce = false
                                        }
                                    }
                                }
                                
                                game.checkAnswer(option)
                                
                            }) {
                                Text("\(option)")
                                    .font(.title2)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(game.getButtonColor(for: option))
                                    .cornerRadius(25)
                                    .shadow(color: Color(red: 140/255, green: 60/255, blue: 255/255), radius: 10)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: game.questionIndexCategory)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 5)
                            
                            Rectangle()
                                .fill(game.getProgressBarColor())
                                .frame(width: geometry.size.width * CGFloat(game.questionTimeLeft) / 2.5)
                                .frame(height: 6)
                                .animation(.linear(duration: 1.0), value: game.questionTimeLeft)
                        }
                    }
                    .frame(height: 5)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .padding(.horizontal)
            .onAppear { game.startGame() }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct MathPuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        MathPuzzleView()
    }
}
