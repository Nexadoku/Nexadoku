//
//  TabBarButton.swift
//  Sudoku
//
//  Created by Helter Skelter on 19/03/25.
//

import SwiftUI

struct TabBarButton: View {
    var image: String
    var isSelected: Bool
    
    var body: some View {
        Image(systemName: image)
            .font(.system(size: 28))
           
            .foregroundStyle(
                LinearGradient(
                    colors: isSelected ? [Color.purple, Color.indigo] : [Color.white.opacity(0.6)],
                                                                         startPoint: .topLeading,
                                                                         endPoint: .bottomTrailing))
           
            .scaleEffect(isSelected ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}
