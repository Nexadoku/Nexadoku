
import Foundation
import UIKit

class VibrationManager {
    static let shared = VibrationManager()
    
    func vibrate(type: UINotificationFeedbackGenerator.FeedbackType = .error) {
        let isVibrationEnabled = UserDefaults.standard.bool(forKey: "vibrationEnabled")
        guard isVibrationEnabled else { return }
        
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    func lightImpact() {
        let isVibration = UserDefaults.standard.bool(forKey: "vibrationEnabled")
        guard isVibration else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func heavyImpact() {
        let isVibrationEnabled = UserDefaults.standard.bool(forKey: "vibrationEnabled")
        guard isVibrationEnabled else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func strongErrorVibration() {
        let isVibrationEnabled = UserDefaults.standard.bool(forKey: "vibrationEnabled")
        guard isVibrationEnabled else { return }
        
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            let second = UIImpactFeedbackGenerator(style: .heavy)
            second.prepare()
            second.impactOccurred()
        }
    }
}
