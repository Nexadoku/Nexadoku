
import SwiftUI

struct EventsView: View {
    @EnvironmentObject private var navigator: Navigator
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            SystemDarkBackground()
            ScrollView {
                VStack(spacing: 35) {
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
                        
                        Text("TRIALS")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(.white)
                            .shadow(radius: 20)
                        
                        Spacer()
                            
                    }
                    .padding()
                    VStack(spacing: 0) {
                        PuzzleCardView(
                            title: "Fast Math",
                            description: "Solve complex math puzzles using logic and numbers.",
                            image: "purpleCalculator", // Изображение
                            action: {
                                navigator.push(.event(.mathPuzzle))
                                VibrationManager.shared.lightImpact()
                            })
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
            .environmentObject(Navigator())
    }
}
