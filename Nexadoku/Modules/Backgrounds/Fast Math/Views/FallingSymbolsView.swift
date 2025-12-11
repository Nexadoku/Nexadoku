
import SwiftUI

struct FallingSymbolsView: View {
    let symbol: FallingSybmols
    
    @State private var y: CGFloat = -200
    
    var body: some View {
        Text(symbol.value)
            .font(.system(size: symbol.size, weight: .bold))
            .foregroundColor(Color(red: 150/255, green: 60/255, blue: 255/255).opacity(0.28))
            .position(x: symbol.x, y: y)
            .onAppear {
                withAnimation(Animation.linear(duration: symbol.speed).delay(symbol.delay).repeatForever(autoreverses: false)) {
                    y = UIScreen.main.bounds.height + 200
            }
        }
    }
}
