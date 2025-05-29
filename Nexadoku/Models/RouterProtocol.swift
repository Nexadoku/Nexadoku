
import SwiftUI

public protocol RouterProtocol {
    associatedtype Content: View
    
    func view() -> Content
}
