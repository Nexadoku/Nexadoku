//
//  GameTimer .swift
//  SUDOKU
//
//  Created by Helter Skelter on 22/04/25.
//

import Foundation


final class GameTimer: ObservableObject {
    @Published private(set) var elapsedTime: Int = 0
    
    private var timer: Timer?
    private var startDate: Date?
    private var accumulatedTime: Int
    
    init(accumulatedTime: Int = 0) {
        self.accumulatedTime = accumulatedTime
    }
    
    func start() {
        guard timer == nil else { return }
        
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            handleTimer()
        }
    }
    
    func stop() {
        if let start = startDate {
            accumulatedTime += Int(Date().timeIntervalSince(start))
        }
        
        timer?.invalidate()
        timer = nil
        startDate = nil
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        startDate = nil
        accumulatedTime = 0
        elapsedTime = 0
    }
    
    private func handleTimer() {
        guard let start = startDate else { return }
        elapsedTime = accumulatedTime + Int(Date().timeIntervalSince(start))
    }
}
