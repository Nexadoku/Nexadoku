
import SwiftUI
import Foundation

struct MathPuzzleQuestion {
    let question: String
    let answer: Int
}

class MathPuzzleGame: ObservableObject {
    
    @Published var categoryIndex = 0
    @Published var questionIndexCategory = 0
    @Published var score = 0
    @Published var gameOver = false
    @Published var selectedAnswer: Int? = nil
    @Published var currentOption: [Int] = []
    @Published var questionTimeLeft = 2.5
    @Published var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @Published var waitingForFirstTap = true
    
    var timer: Timer?
    
    let questions2Digits: [MathPuzzleQuestion] = [
        MathPuzzleQuestion(question: "1 + 2", answer: 3),
        MathPuzzleQuestion(question: "1 + 1", answer: 2),
        MathPuzzleQuestion(question: "2 + 1", answer: 3),
        MathPuzzleQuestion(question: "3 - 1", answer: 2),
        MathPuzzleQuestion(question: "3 - 2", answer: 1),
        MathPuzzleQuestion(question: "2 - 1", answer: 1)
    ]
    
    let questions3Digits: [MathPuzzleQuestion] = [
        MathPuzzleQuestion(question: "1 - 3 + 3 ", answer: 1),
        MathPuzzleQuestion(question: "1 - 2 + 2", answer: 1),
        MathPuzzleQuestion(question: "3 + 2 - 2", answer: 3),
        MathPuzzleQuestion(question: "2 + 2 - 2", answer: 2),
        MathPuzzleQuestion(question: "1 - 1 + 1", answer: 1),
        MathPuzzleQuestion(question: "3 + 3 - 3", answer: 3),
        MathPuzzleQuestion(question: "3 + 1 - 3", answer: 1),
        MathPuzzleQuestion(question: "3 + 2 - 3", answer: 2),
        MathPuzzleQuestion(question: "1 + 3 - 2", answer: 2),
        MathPuzzleQuestion(question: "3 - 1 - 1", answer: 1),
        MathPuzzleQuestion(question: "3 + 1 - 1", answer: 3),
        MathPuzzleQuestion(question: "2 - 1 + 1", answer: 2),
        MathPuzzleQuestion(question: "1 + 3 - 1", answer: 3)
    ]
    
    let questions4Digits: [MathPuzzleQuestion] = [
        MathPuzzleQuestion(question: "1 + 2 - 1 + 1", answer: 3),
        MathPuzzleQuestion(question: "2 + 1 - 1 - 1", answer: 1),
        MathPuzzleQuestion(question: "3 - 2 + 1 + 1", answer: 3),
        MathPuzzleQuestion(question: "2 + 2 - 1 - 1", answer: 2),
        MathPuzzleQuestion(question: "3 - 1 - 1 + 2", answer: 3),
        MathPuzzleQuestion(question: "1 + 1 + 1 - 2", answer: 1),
        MathPuzzleQuestion(question: "2 - 1 + 2 - 1", answer: 2),
        MathPuzzleQuestion(question: "3 - 2 + 2 - 1", answer: 2),
        MathPuzzleQuestion(question: "1 + 3 - 2 - 1", answer: 1),
        MathPuzzleQuestion(question: "2 + 1 + 1 - 1", answer: 3)
    ]
    
    let questions4DigitsWithBrackets: [MathPuzzleQuestion] = [
        MathPuzzleQuestion(question: "(1 + 2) - 1 + 1", answer: 3),
        MathPuzzleQuestion(question: "1 + (3 - 2) - 1", answer: 1),
        MathPuzzleQuestion(question: "2 + (2 - 1) - 1", answer: 2),
        MathPuzzleQuestion(question: "(3 - 1) + 1 - 2", answer: 1),
        MathPuzzleQuestion(question: "(2 + 1) - 2 + 2", answer: 3),
        MathPuzzleQuestion(question: "1 + (1 + 1) - 2", answer: 1),
        MathPuzzleQuestion(question: "3 - (2 - 1) - 1", answer: 1),
        MathPuzzleQuestion(question: "(3 - 2) + 1 + 1", answer: 3),
        MathPuzzleQuestion(question: "2 - (1 - 1) + 1", answer: 3),
        MathPuzzleQuestion(question: "(2 + 2) - 1 - 2", answer: 1)
    ]
    
    lazy var groupedQuestions: [[MathPuzzleQuestion]] = [
        questions2Digits.shuffled(),
        questions3Digits.shuffled(),
        questions4Digits.shuffled(),
        questions4DigitsWithBrackets.shuffled()
    ]
    
    var currentQuestion: MathPuzzleQuestion {
        groupedQuestions[categoryIndex][questionIndexCategory]
    }
    
    func startGame() {
        categoryIndex = 0
        questionIndexCategory = 0
        score = 0
        gameOver = false
        selectedAnswer = nil
        waitingForFirstTap = true
        
        groupedQuestions = [
            questions2Digits.shuffled(),
            questions3Digits.shuffled(),
            questions4Digits.shuffled(),
            questions4DigitsWithBrackets.shuffled()
        ]
        
        generateOptions()
    }
    
    func startQuestionTimer() {
        timer?.invalidate()
        questionTimeLeft = 2.5
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.questionTimeLeft > 0 {
                self.questionTimeLeft -= 1.0
            } else {
                SoundManager.shared.playSound(named: "error")
                VibrationManager.shared.strongErrorVibration()
                self.timer?.invalidate()
                self.finishGame()
            }
        }
    }
    
    func generateOptions() {
        let correct = currentQuestion.answer
        var options = [correct]
        
        while options.count < 3 {
            let random = Int.random(in: (correct - 1)...(correct + 1))
            if random != correct && !options.contains(random) {
                options.append(random)
            }
        }
        currentOption = options.shuffled()
    }
    
    func checkAnswer(_ answer: Int) {
        
        if waitingForFirstTap {
            waitingForFirstTap = false
            startQuestionTimer()
        }
        
        selectedAnswer = answer
        timer?.invalidate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if answer == self.currentQuestion.answer {
                VibrationManager.shared.lightImpact()
                SoundManager.shared.playSound(named: "FastMathCorrect")
                self.score += 1
                self.moveToNextQuestion()
            } else {
                SoundManager.shared.playSound(named: "error")
                VibrationManager.shared.strongErrorVibration()
                self.finishGame()
            }
        }
    }
    
    func moveToNextQuestion() {
        let currentCategory = groupedQuestions[categoryIndex]
        
        if questionIndexCategory < currentCategory.count - 1 {
            questionIndexCategory += 1
        } else {
            if categoryIndex < groupedQuestions.count - 1 {
                categoryIndex += 1
                questionIndexCategory = 0
            } else {
                finishGame()
                return
            }
        }
        
        selectedAnswer = nil
        generateOptions()
        startQuestionTimer()
    }
    
    func stopGame() {
        timer?.invalidate()
        timer = nil
        waitingForFirstTap = true
    }
    
    func finishGame() {
        gameOver = true
        
        FastMathStatsManager.shared.addScore(score)
        
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
                return option == currentQuestion.answer ? .green : .red
            }
        }
        return Color(red: 140/255, green: 60/255, blue: 255/255)
    }
    
    func getProgressBarColor() -> Color {
        if questionTimeLeft > 1.50 {
            return .green
        } else if questionTimeLeft > 1 {
            return .yellow
        } else {
            return .red
        }
    }

}
