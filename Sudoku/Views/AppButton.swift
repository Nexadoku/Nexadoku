//
//  AppButton.swift
//  SUDOKU
//
//  Created by Helter Skelter on 13/04/25.
//

import SwiftUI

struct AppButton: View {
    private let text: String
    private let action: () -> Void
    
    init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(text)
        }
        .buttonStyle(AppButtonStyle())
    }
}

extension AppButton {
    enum Variation {
        case primary
        case secondary
        case destructive
    }
    
    struct AppButtonStyle: ButtonStyle {
        @Environment(\.appButtonVariation) private var variation
        
        private var backgroundColor: Color {
            switch variation {
            case .primary: .clear
            case .secondary: Color(uiColor: .darkGray)
            case .destructive: Color.red
            }
        }
        
        private var gradient: LinearGradient {
            switch variation {
            case .primary:
                LinearGradient(
                    colors: [.purple, .indigo],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            default:
                LinearGradient(
                    colors: [Color.clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        
        private var foregroundColor: Color {
            switch variation {
            default: .white
            }
        }
        
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                configuration.label
                    .font(.title3.bold())
                    .foregroundColor(foregroundColor)
            }
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background {
                backgroundColor
                gradient
            }
            .clipShape(.capsule)
        }
    }

}

extension EnvironmentValues {
    @Entry var appButtonVariation: AppButton.Variation = .primary
}

extension View {
    func appButtonVariation(_ variation: AppButton.Variation) -> some View {
        self.environment(\.appButtonVariation, variation)
    }
}
