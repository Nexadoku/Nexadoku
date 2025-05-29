
import SwiftUI
import Combine

final class UnlockSheetManager: ObservableObject {
    @Published var unlockedTrophy: Trophy? = nil
    
    func show(trophy: Trophy) {
        withAnimation(.easeInOut) {
            unlockedTrophy = trophy
        }
    }
    
    func hide() {
        withAnimation(.easeInOut) {
            unlockedTrophy = nil
        }
    }
}
