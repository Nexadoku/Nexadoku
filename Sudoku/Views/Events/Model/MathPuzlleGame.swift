
import SwiftUI
import Foundation

struct MathPuzzleQuestion {
    let question: String
    let answer: Int
}
class MathPuzzleGame: ObservableObject {
    @Published var currentQuestionIndex = 0
    @Published var score = 0
    @Published var gameOver = false
    @Published var currentOptions: [Int] = []
    @Published var selectedAnswer: Int? = nil
    @Published var questionTimeLeft = 3
    @Published var progress: CGFloat = 1.0
    @Published var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    

    let questions = [
        MathPuzzleQuestion(question: "1 + 2", answer: 3),
        MathPuzzleQuestion(question: "1 + 1", answer: 2),
        MathPuzzleQuestion(question: "2 + 1", answer: 3),
        MathPuzzleQuestion(question: "3 - 1", answer: 2),
        MathPuzzleQuestion(question: "3 - 2", answer: 1),
        MathPuzzleQuestion(question: "2 - 1", answer: 1),
        MathPuzzleQuestion(question: "1 - 3 + 3 ", answer: 1),
        MathPuzzleQuestion(question: "1 - 2 + 2", answer: 1),
        MathPuzzleQuestion(question: "3 + 2 - 2", answer: 3),
        MathPuzzleQuestion(question: "2 + 2 - 2", answer: 2),
        MathPuzzleQuestion(question: "1 - 1 + 1", answer: 1),
        MathPuzzleQuestion(question: "3 + 3 - 3", answer: 3),
        MathPuzzleQuestion(question: "3 + 1 - 3", answer: 1),
        MathPuzzleQuestion(question: "3 + 2 - 3", answer: 2),
        MathPuzzleQuestion(question: "1 + 3 - 2", answer: 2)
    ]

    var timer: Timer?

    func startGame() {
        currentQuestionIndex = 0
        score = 0
        gameOver = false
        selectedAnswer = nil
        currentOptions = []
        generateOptions()
        startQuestionTimer()
    }

    func startQuestionTimer() {
        timer?.invalidate()
        questionTimeLeft = 3

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.questionTimeLeft > 0 {
                self.questionTimeLeft -= 1
            } else {
                self.timer?.invalidate()
                self.finishGame()
            }
        }
    }

    func generateOptions() {
        let correctAnswer = questions[currentQuestionIndex].answer
        var options = [correctAnswer]
        while options.count < 3 {
            let randomOption = Int.random(in: (correctAnswer - 5)...(correctAnswer + 5))
            if randomOption != correctAnswer && !options.contains(randomOption) {
                options.append(randomOption)
            }
        }
        currentOptions = options.shuffled()
    }

    func checkAnswer(_ answer: Int) {
        selectedAnswer = answer
        timer?.invalidate()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if answer == self.questions[self.currentQuestionIndex].answer {
                self.score += 1
                self.moveToNextQuestion()
            } else {
                self.finishGame()
            }
        }
    }

    func moveToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
            generateOptions()
            startQuestionTimer()
        } else {
            finishGame()
        }
    }
    
    func finishGame() {
        gameOver = true
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "HighScore")
        }
    }

    func restartGame() {
        timer?.invalidate()
        startGame()
    }

    func getButtonColor(for option: Int) -> Color {
        if let selected = selectedAnswer {
            if selected == option {
                return option == questions[currentQuestionIndex].answer ? .green : .red
            }
        }
        return .purple
    }

    func getProgressBarColor() -> Color {
        if questionTimeLeft > 2 {
            return .green
        } else if questionTimeLeft > 1 {
            return .yellow
        } else {
            return .red
        }
    }
}
