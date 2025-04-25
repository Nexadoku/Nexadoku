
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
                    
                    PuzzleCardView(
                        title: "Fast Math",
                        description: "Solve complex math puzzles using logic and numbers.",
                        image: "mathPuzzleImage", // Изображение
                        action: {
                            navigator.push(.event(.mathPuzzle))
                        })
                   }
            .padding(.horizontal)
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
