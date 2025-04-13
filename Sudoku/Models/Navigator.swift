//
//  Navigator.swift
//  Sudoku
//
//  Created by Helter Skelter on 21/03/25.
//

import SwiftUI

public final class Navigator: ObservableObject {
    @Published public var stack: [Destination] = []
    @Published public var selectedTab: AppTab = .menu
    
    public func push(_ destination: Destination) {
        withAnimation {
            stack.append(destination)
        }
    }
    
    public func pop() {
        stack.removeLast()
    }
    
    public func popToRoot() {
        if !stack.isEmpty {
            stack = [stack.first!]
        }
    }
}
