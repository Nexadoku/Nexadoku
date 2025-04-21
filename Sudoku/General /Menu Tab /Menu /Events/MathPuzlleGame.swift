
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
    @Published var timeLeft = 50
    @Published var currentOptions: [Int] = []
    @Published var selectedAnswer: Int? = nil
    @Published var questionTimeLeft = 10
    
    let questions = [
        MathPuzzleQuestion(question: "5 + 7", answer: 12),
        MathPuzzleQuestion(question: "15 - 6", answer: 9),
        MathPuzzleQuestion(question: "9 * 3", answer: 27),
        MathPuzzleQuestion(question: "18 / 3", answer: 6),
        MathPuzzleQuestion(question: "25 + 13", answer: 38),
        MathPuzzleQuestion(question: "12 * 4", answer: 48),
        MathPuzzleQuestion(question: "72 / 8", answer: 9),
        MathPuzzleQuestion(question: "58 + 85", answer: 143)
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
        questionTimeLeft = 6
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.questionTimeLeft > 0 {
                self.questionTimeLeft -= 1
            } else {
                self.score -= 1
                self.nextQuestion()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if answer == self.questions[self.currentQuestionIndex].answer {
                self.score += 1
            } else {
                self.score -= -1
            }
            self.nextQuestion()
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            generateOptions()
            selectedAnswer = nil
            startQuestionTimer()
        } else {
            gameOver = true
            timer?.invalidate()
        }
    }
    
    func restartGame() {
        timer?.invalidate()
        startGame()
    }
    
    func getButtonColor(for option: Int) -> Color {
        if let selected = selectedAnswer {
            if selected == option {
                return option == questions[currentQuestionIndex].answer ? Color.green : Color.red
            }
        }
        return Color.purple
    }
    
    func getProgressBarColor() -> Color {
        if timeLeft > 6 {
            return .green
        } else if timeLeft > 3 {
            return .yellow
        } else {
            return .red
        }
    }
}
