
import SwiftUI

struct LevelSelectionView: View {
    
    @State private var animateBackground = false
    @State private var showLevels = false
    @State private var selectedLevel: DifficultyLevel? = nil
    @State private var startGame = false
    @State private var showInfoSheet = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var navigator: Navigator
    @ObservedObject private var progress = ProgressManager.shared
    @AppStorage("isPremium") private var isPremium = false
    
    var body: some View {
        ZStack {
            SystemBackground()
                .animation(Animation.easeInOut(duration: 3).repeatForever(), value: animateBackground)
                .onAppear {
                    animateBackground.toggle()
                    withAnimation(.easeIn(duration: 1)) {
                        showLevels = true
                    }
                }
        
                VStack(spacing: 40) {
                   
                        Text("Select Level:")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .shadow(radius: 20)
                            .padding(.top, 50)
                        
                    
                    
                    if showLevels {
                        VStack(spacing: 20) {
                            HStack(spacing: 20) {
                                levelButton(title: .easy, color: .green)
                                levelButton(title: .medium, color: .yellow)
                                levelButton(title: .hard, color: .orange)
                            }
                            
                            HStack {
                                levelButton(title: .master, color: .red)
                                levelButton(title: .epic, color: .black)
                                levelButton(title: .legend, color: .teal)
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    if let level = selectedLevel {
                        Text("Selected Level: \(level.rawValue)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.top, 20)
                            .transition(.opacity)
                            .shadow(radius: 20)
                        
                        Button(action: {
                            navigator.push(
                                .level(.game(.new(level: level)))
                            )
                            
                        }) {
                            Text("Start Game")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                                .padding()
                                .frame(width: 250)
                                .background(.purple)
                                .cornerRadius(20)
                                .shadow(color: .purple, radius: 10)
                        }
                        .transition(.opacity.combined(with: .scale))
                        
                    }
                }
                .padding()
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            showInfoSheet.toggle()
                        }
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.white.opacity(0.4))
                            .font(.system(size: 26, weight: .bold))
                            .padding()
                    }
                }
                Spacer()
            }
                
                VStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                        VibrationManager.shared.lightImpact()
                    }) {
                        Text("← Back")
                            .foregroundColor(.white)
                            .font(.headline.bold())
                            .frame(width: 180, height: 50)
                            .background(.purple)
                            .cornerRadius(25)
                            .shadow(radius: 20)
                    }
                    .padding(.bottom, 30)
                    .opacity(0.95)
                }
                
                if showInfoSheet {
                    bottomSheet
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .zIndex(10)
                }
            }
            .navigationBarBackButtonHidden()
    }
   
    private func levelButton(title: DifficultyLevel, color: Color) -> some View {
        let isUnlocked: Bool
        if title == .legend {
            isUnlocked = isPremium
        } else {
            isUnlocked = progress.isLevelUnlocked(title)
        }
        return Button(action: {
            if isUnlocked {
                withAnimation {
                    selectedLevel = title
                }
                SoundManager.shared.playSound(named: "levelSelection")
                VibrationManager.shared.lightImpact()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(LinearGradient(
                        colors: isUnlocked ? [color.opacity(0.8), color] : [.gray.opacity(0.6), .gray.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .frame(width: 110, height: 90)
                    .shadow(color: isUnlocked ? color : .purple, radius: 10)
                
                VStack {
                    Text(title.rawValue)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    if !isUnlocked {
                        if title == .legend {
                            // Premium lock
                            HStack(spacing: 6) {
                                Text("Premium")
                                    .foregroundStyle(
                                        LinearGradient(colors: [.purple, .white, .teal], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .font(.caption.bold())
                            }
                        } else {
                            // Обычный замок
                            Text("🔒")
                                .font(.title2)
                                .opacity(0.7)
                        }
                    } else {
                        Text("✓ \(progress.winsCount(for: title))")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
        }
        .disabled(!isUnlocked)
    }
    
    private var bottomSheet: some View {
        VStack(spacing: 20) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.white.opacity(0.4))
                .padding(.top, 8)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("📖 How levels work?")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Text("• To unlock Medium, win Easy 2 times\n• To unlock Hard, win Medium 4 times\n• To unlock Master, win Hard 6 times\n• To unlock Epic, win Master 8 times\n\nPlay and discover new levels!")
                        .foregroundColor(.white.opacity(0.9))
                        .font(.body)
                        .multilineTextAlignment(.leading)
                    
                    Divider().background(.white.opacity(0.2))
                    
                    HStack(alignment: .top, spacing: 6) {
                        Image(systemName: "sparkles")
                            .foregroundStyle(
                                LinearGradient(colors: [.white, .teal], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .font(.system(size: 20))
                            .padding(.top, 2)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Legend level")
                                .font(.headline.bold())
                                .foregroundStyle(
                                    LinearGradient(colors: [.white, .teal], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                            Text("""
                                The **Legend** level is only available for Premium users.
                                Buy Premium to challange yourself with the most epic Sudoku puzzles ever!
                                """)
                            .foregroundColor(.white.opacity(0.85))
                        }
                    }
                }
                .padding()
            }
            
            Button(action: {
                withAnimation {
                    showInfoSheet = false
                }
            }) {
                Text("Close")
                    .font(.headline.bold())
                    .foregroundColor(.purple)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .cornerRadius(16)
                    .shadow(radius: 10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(LinearGradient(colors: [.purple], startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .frame(maxWidth: .infinity)
        .frame(height: 400)
        .padding()
    }
}

struct LevelSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LevelSelectionView()
            .preferredColorScheme(.dark)
            .environmentObject(LanguageSettings())
            .environmentObject(UnlockSheetManager())
    }
}
