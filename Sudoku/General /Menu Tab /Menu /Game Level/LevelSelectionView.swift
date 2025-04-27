
import SwiftUI

struct LevelSelectionView: View {
    
    @State private var animateBackground = false
    @State private var showLevels = false
    @State private var selectedLevel: DifficultyLevel? = nil
    @State private var startGame = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var navigator: Navigator
    @ObservedObject private var progress = ProgressManager.shared
    
    var body: some View {
        ZStack {
            SystemDarkBackground()
                .animation(Animation.easeInOut(duration: 3).repeatForever(), value: animateBackground)
                .onAppear {
                    animateBackground.toggle()
                    withAnimation(.easeIn(duration: 1)) {
                        showLevels = true
                    }
                }
            
            
            VStack(spacing: 40) {
                Text("select_level")
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
                        Text("start_game")
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
                Spacer()
                Button(action: {
                    dismiss()
                    VibrationManager.shared.lightImpact()
                }) {
                    Text("back_button")
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
        }
        .navigationBarBackButtonHidden()
    }
    
    private func levelButton(title: DifficultyLevel, color: Color) -> some View {
        let isUnlocked = progress.isLevelUnlocked(title)
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
                        Text("🔒")
                            .font(.title2)
                            .opacity(0.7)
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
}

struct LevelSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LevelSelectionView()
            .preferredColorScheme(.dark)
    }
}
