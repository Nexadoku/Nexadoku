
import SwiftUI

struct EventsView: View {
    @EnvironmentObject private var navigator: Navigator
    @Environment(\.dismiss) var dismiss
    @State private var animate = false
    
    var body: some View {
        ZStack {
            SystemBackground()
            
            ScrollView {
                VStack(spacing: 35) {
                    
                    EventCardView(
                        title: "Fast Math",
                        description: "Solve complex math puzzles using logic and numbers.",
                        image: "purpleCalculator",
                        action: {
                            navigator.push(.event(.mathPuzzle))
                            VibrationManager.shared.lightImpact()
                        }
                    )
                }
                .padding(.top, 20)
            }
            .opacity(animate ? 1 : 0)
            .offset(y: animate ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(0.1), value: animate)
        }
        .onAppear { animate = true }
        .navigationBarBackButtonHidden(true)
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
            .environmentObject(Navigator())
    }
}
