//
//  SecondLaunchScreen.swift
//  SUDOKU
//
//  Created by Helter Skelter on 14/04/25.
//

import SwiftUI

struct SecondLaunchScreen: View {
    @State private var textOffset: CGFloat = 50
    @State private var textOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("SUDOKU")
                .foregroundColor(.white)
                .font(.system(size: 40, weight: .heavy))
                .offset(y: textOffset)
                .opacity(textOpacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        textOffset = 0
                        textOpacity = 1.0
                }
            }
        }
    }
}

struct SecondLaunchScreenPreviews: PreviewProvider {
    static var previews: some View {
        SecondLaunchScreen()
    }
}
