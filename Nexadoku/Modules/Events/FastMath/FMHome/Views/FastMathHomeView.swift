
import Foundation
import SwiftUI

struct FastMathHomeView: View {
    @EnvironmentObject private var navigator: Navigator
    @Environment(\.dismiss) var dismiss
    @State private var animate = false
    
    var body: some View {
        ZStack {
            FastMathRainBackgorund()
            VStack(spacing: 25) {
                HStack {
                    Button {
                        dismiss()
                        VibrationManager.shared.lightImpact()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .heavy))
                            .shadow(radius: 10)
                    }
                    
                    Text("FAST MATH HOME")
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundColor(.white)
                        .shadow(radius: 10)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                Spacer()
                
                GlassPurpleButton(title: "Start") {
                    navigator.push(.event(.mathPuzzle))
                    VibrationManager.shared.lightImpact()
                }
                
                GlassPurpleButton(title: "Statistics") {
                    navigator.push(.event(.fastMathStatistics))
                    VibrationManager.shared.lightImpact()
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
