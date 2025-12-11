
import Foundation
import SwiftUI

extension Date {
    func formattedFM() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
}
