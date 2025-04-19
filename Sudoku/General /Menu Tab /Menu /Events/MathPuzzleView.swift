
import SwiftUI

struct MathPuzzleView: View {
    @ObservedObject var game = MathPuzzleGame()
    
    var body: some View {
        ZStack {
            SystemDarkBackground()
            
            VStack {
                Text("Fast Math")
                    .font(.system(size: 44, weight: .heavy))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .padding(.top, 30)
                
                Spacer()
                
                if game.gameOver {
                    VStack {
                        Text(game.score <= 0 ? "You Lose!" : "You Win!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                        
                        Text("Score: \(game.score)")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                        
                        Button(action: {
                            game.restartGame()
                        }) {
                            Text("Restart Game")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(.purple)
                                .cornerRadius(20)
                                .shadow(color: .purple, radius: 10)
                        }
                        .padding(.top, 20)
                    }
                } else {
                    Text(game.questions[game.currentQuestionIndex].question)
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    
                    VStack(spacing: 15) {
                        ForEach(game.currentOptions, id: \ .self) { option in
                            Button(action: {
                                game.checkAnswer(option)
                            }) {
                                Text("\(option)")
                                    .font(.title2)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(game.getButtonColor(for: option))
                                    .cornerRadius(25)
                                    .shadow(color: .purple, radius: 10)
                                    
                            }
                        }
                    }
                    .padding()
                    
                    Text("Time Left: \(game.questionTimeLeft) sec")
                        .font(.system(size: 27, weight: .heavy))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 5)
                        
                        Rectangle()
                            .fill(game.getProgressBarColor())
                            .frame(width: CGFloat(game.questionTimeLeft) / 10 * UIScreen.main.bounds.width, height: 3)
                            .animation(.linear(duration: 0.1), value: game.questionTimeLeft)
                    }
                    .padding(.bottom, 20)
                    
                    Spacer()
                }
            }
            .padding(.horizontal)
            .onAppear {
                game.startGame()
            }
        }
    }
}

struct MathPuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        MathPuzzleView()
    }
}
