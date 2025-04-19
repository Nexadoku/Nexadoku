
import SwiftUI

struct MenuTabView: View {
    @EnvironmentObject private var navigator: Navigator
    
    var body: some View {
        NavigationStack(path: $navigator.stack) {
            ZStack {
                Group {
                    switch navigator.selectedTab {
                    case .menu:
                        MenuView()
                    case .account:
                        AccountView()
                    }
                }
                VStack {
                    Spacer()
                    CustomTabBar(selectedTab: $navigator.selectedTab)
                }
            }
            .navigationDestination(
                for: Destination.self,
                destination: buildDestination
            )
        }
    }
    
    @ViewBuilder
    private func buildDestination(_ destination: Destination) -> some View {
        switch destination {
        case .menu(let route):
            MenuRouter(route: route).view()
        case .account(let route):
            AccountRouter(route: route).view()
        case .event(let route):
            EventsRouter(route: route).view()
        case .level(let route):
            LevelRouter(route: route).view()
        }
    }
}

struct MenuTabViewPreviews: PreviewProvider {
    static var previews: some View {
        MenuTabView()
            .environmentObject(Navigator())
            .environmentObject(LanguageSettings())
            .preferredColorScheme(.dark)
    }
}
