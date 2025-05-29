
import SwiftUI

struct LaunchScreenView: View {
    @State private var showSecondScreen = false
    @State private var showMainView = false

    
    var body: some View {
        Group {
            if showMainView {
                MenuTabView()
            } else if showSecondScreen {
                SecondLaunchScreen()
                    .transition(.opacity)
            } else {
                FirstLaunchScreen()
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation {
                    showSecondScreen = true
                }
                // Через ещё 1.3 секунды переходим к основному экрану
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation {
                        showMainView = true
                    }
                }
            }
        }
    }
}

struct LaunchScreenPreviews: PreviewProvider {
  static var previews: some View {
    LaunchScreenView()
    .environmentObject(Navigator())
  }
}

