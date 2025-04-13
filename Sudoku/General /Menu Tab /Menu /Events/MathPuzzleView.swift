
import SwiftUI

struct MathPuzzleView: View {
    @ObservedObject var game = MathPuzzleGame()
    
    var body: some View {
        ZStack {
            LuxuriousDarkBackgroundView()
            
            VStack {
                Text("Fast Math")
                    .font(.system(size: 44, weight: .heavy))
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
                                .background(
                                    LinearGradient(colors: [.indigo, .purple], startPoint: .bottomLeading, endPoint: .topTrailing)
                                )
                                .cornerRadius(20)
                                .shadow(color: .purple, radius: 10)
                                .shadow(color: .indigo, radius: 10)
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
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(game.getButtonColor(for: option))
                                    .cornerRadius(25)
                                    .shadow(color: .purple, radius: 10)
                                    .shadow(color: .indigo, radius: 10)
                            }
                        }
                    }
                    .padding()
                    
                    Text("Time Left: \(game.timeLeft) sec")
                        .font(.system(size: 27, weight: .heavy))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
            }
            .padding(.horizontal)
            .onAppear {
                game.startTimer()
            }
        }
    }
}

struct MathPuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        MathPuzzleView()
    }
}
