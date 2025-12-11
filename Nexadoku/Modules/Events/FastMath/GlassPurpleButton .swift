
import SwiftUI

struct GlassPurpleButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title2.bold())
                .foregroundColor(.white)
                .frame(maxWidth: 500, maxHeight: 30)
                .padding()
                .background(GlassProfileBackground(cornerRadius: 25))
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .shadow(color: Color.black.opacity(0.35), radius: 14, x: 0, y: 10)
                .shadow(color: Color.white.opacity(0.06), radius: 6, x: -2, y: -2)
        }
        .padding(.horizontal)
    }
}
