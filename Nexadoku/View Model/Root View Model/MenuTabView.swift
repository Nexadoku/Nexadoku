
import SwiftUI

struct MenuTabView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var storeManager: StoreManager
    
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
                .safeAreaInset(edge: .bottom) {
                    CustomTabBar(selectedTab: $navigator.selectedTab)
                }
            }
            .navigationDestination(
                for: Destination.self,
                destination: buildDestination
            )
        }
        .environment(\.colorScheme, .dark)
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
        case .menuTab(let route):
            MenuTabRouter(route: route).view()
        }
    }
}

struct MenuTabViewPreviews: PreviewProvider {
    static var previews: some View {
        MenuTabView()
            .environmentObject(Navigator())
            .environmentObject(LanguageSettings())
            .environmentObject(StoreManager())
            .preferredColorScheme(.dark)
    }
}
