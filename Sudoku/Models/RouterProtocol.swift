//
//  RouterProtocol.swift
//  Sudoku
//
//  Created by Helter Skelter on 21/03/25.
//

import SwiftUI

public protocol RouterProtocol {
    associatedtype Content: View
    
    func view() -> Content
}
