
import SwiftUI

struct MenuTabView: View {
    @EnvironmentObject private var navigator: Navigator
    @StateObject private var unlockManager = UnlockSheetManager()
    
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
                
                if let trophy = unlockManager.unlockedTrophy {
                    RewardsUnlockSheet(trophy: trophy) {
                        unlockManager.hide()
                    }
                    .zIndex(1000)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .ignoresSafeArea()
                }
            }
            .navigationDestination(
                for: Destination.self,
                destination: buildDestination
            )
        }
        .environmentObject(unlockManager)
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
            .environmentObject(UnlockSheetManager())
            .preferredColorScheme(.dark)
    }
}
