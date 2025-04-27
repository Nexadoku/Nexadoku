
import SwiftUI

struct MathPuzzleView: View {
    @ObservedObject var game = MathPuzzleGame()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            SystemDarkBackground()
            
            VStack {
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
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                    
                    Spacer()
                       
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 10)
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
                        
                        Text("Best Score: \(game.highScore)")
                            .font(.title2)
                            .foregroundColor(.yellow)
                            .padding(.bottom, 10)
                        
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
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 5)
                            
                            Rectangle()
                                .fill(game.getProgressBarColor())
                                .frame(width: geometry.size.width * CGFloat(game.questionTimeLeft) / 4.0, height: 5)
                                .animation(.linear(duration: 1.0), value: game.questionTimeLeft)
                        }
                        .cornerRadius(3)
                    }
                    .frame(height: 5)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    Spacer()
                }
            }
            .padding(.horizontal)
            .onAppear {
                game.startGame()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct MathPuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        MathPuzzleView()
    }
}
