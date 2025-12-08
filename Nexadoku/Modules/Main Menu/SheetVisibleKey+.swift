
import Foundation
import SwiftUI

extension EnvironmentValues {
    var sheetIsVisible: Bool {
        get { self[SheetVisibleKey.self] }
        set { self[SheetVisibleKey.self] = newValue }
    }
}
