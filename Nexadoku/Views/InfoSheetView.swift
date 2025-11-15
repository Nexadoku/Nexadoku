
import SwiftUI

struct InfoSheetView: View {
    var onClose: () -> Void
    
    @State private var appear = false
    @State private var textAppear = false
    @State private var glow = false
    
    var body: some View {
        ZStack {
            glassBackground
            
            VStack(spacing: 20) {
               
                Image("infoSheet")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 200, maxHeight: 200)
                    .opacity(textAppear ? 1 : 0)
                    .offset(y: textAppear ? 0 : 20)
                    .animation(.easeInOut(duration: 0.2).delay(0.2), value: textAppear)
                    .shadow(color: .indigo, radius: 10)
                
                Text("How Levels Work?")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundColor(.white)
                    .opacity(textAppear ? 1 : 0)
                    .offset(y: textAppear ? 0 : 20)
                    .animation(.easeInOut(duration: 0.4).delay(0.2), value: textAppear)
                
                VStack(alignment: .leading, spacing: 14) {
                    Text("• Win Easy 2 times  → Unlock Medium")
                    Text("• Win Medium 4 times → Unlock Hard")
                    Text("• Win Hard 6 times → Unlock Master")
                    Text("• Win Master 8 times → Unlock Epic")
                    Text("• Win Epic 5 times → Unlock Legend")
                    
                    Divider().background(Color.white.opacity(0.25))
                    
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "sparkles")
                            .foregroundColor(.teal)
                            .font(.system(size: 20))
                            .shadow(color: .teal, radius: 6)
                        Text("Legend level is Premium only. Challenge yourself with the most epic Sudoku puzzles ever!")
                    }
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16)
                .opacity(textAppear ? 1 : 0)
                .offset(y: textAppear ? 0 : 20)
                .animation(.easeInOut(duration: 0.4).delay(0.4), value: textAppear)
                
                Button(action: onClose) {
                    Text("Close")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(glassButton)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding(.horizontal, 20)
                .opacity(textAppear ? 1 : 0)
                .offset(y: textAppear ? 0 : 30)
                .animation(.easeInOut(duration: 0.4).delay(0.6), value: textAppear)
            }
            .padding(32)
        }
        .frame(maxWidth: 380)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .scaleEffect(appear ? 1 : 0.9)
        .opacity(appear ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: appear)
        .onAppear {
            appear = true
            glow = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                textAppear = true
            }
        }
    }
    
    private var glassBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.42),
                            Color(red: 60/255, green: 20/255, blue: 120/255).opacity(0.42)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }
    
    private var glassButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.18),
                            Color.white.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.4), lineWidth: 1)
        }
    }
}

struct InfoSheetViewPreviews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SystemBackground()
            
            InfoSheetView {
                print("Close pressed")
            }
        }
    }
}
