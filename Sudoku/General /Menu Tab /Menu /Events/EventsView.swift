
import SwiftUI

struct EventsView: View {
    @EnvironmentObject private var navigator: Navigator
    
    var body: some View {
        ZStack {
            SystemDarkBackground()
            ScrollView {
                VStack(spacing: 35) {
                    // Карточка 1: Математическая головоломка
                    Text("trials")
                        .font(.system(size: 40, weight: .heavy))
                        .foregroundColor(.white)
                        .shadow(radius: 20)
                        .padding()
                    
                    PuzzleCardView(
                        title: "Fast Math",
                        description: "Solve complex math puzzles using logic and numbers.",
                        image: "mathPuzzleImage", // Изображение
                        action: {
                            navigator.push(.event(.mathPuzzle))
                        })
//                    
//                    PuzzleCardView(
//                        title: "Math Crossword",
//                        description: "Fill the grid with numbers based on given math clues.",
//                        image: "mathCrosswordImage",
//                        action: {
//                            
//                        })
//                    
//                    PuzzleCardView(
//                        title: "Killer Sudoku",
//                        description: "",
//                        image: "killerSudoku",
//                        action: {
//                            
//                        })
//                    
                   }
            .padding(.horizontal)
            }
        }
    }
}


struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
            .environmentObject(Navigator())
    }
}
