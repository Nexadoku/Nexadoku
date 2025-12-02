
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
                    
                    MagicStartButton(title: "Start Game", icon: "sparkles") {
                        navigator.push(.level(.game(.new(level: level))))
                        VibrationManager.shared.lightImpact()
                    }
                    .transition(.opacity.combined(with: .scale))
                    
                }
            }
            .padding()
            .opacity(showInfoSheet ? 0 : 1)
            .scaleEffect(showInfoSheet ? 0.96 : 1)
            .animation(.easeInOut(duration: 0.28), value: showInfoSheet)
            .allowsHitTesting(!showInfoSheet)
            
            
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
                            .opacity(showInfoSheet ? 0 : 0.95)
                            .scaleEffect(showInfoSheet ? 0.96 : 1)
                            .animation(.easeInOut(duration: 0.25), value: showInfoSheet)
                            .allowsHitTesting(!showInfoSheet)
                    }
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                GlassMenuButton(title: "Back", icon: "arrow.left") {
                    dismiss()
                    VibrationManager.shared.lightImpact()
                }
                .padding(.bottom)
                .opacity(showInfoSheet ? 0 : 0.95)
                .scaleEffect(showInfoSheet ? 0.96 : 1)
                .animation(.easeInOut(duration: 0.25), value: showInfoSheet)
                .allowsHitTesting(!showInfoSheet)
            }
            
            if showInfoSheet {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .zIndex(20)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showInfoSheet = false
                        }
                    }
                
                InfoSheetView {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showInfoSheet = false
                    }
                }
                .zIndex(21)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func levelButton(title: DifficultyLevel, color: Color) -> some View {
        let isUnlocked = progress.isLevelUnlocked(title)
        let isLegend = title == .legend
        
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
                    .shadow(color: isUnlocked ? color : Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.7), radius: 10)
                
                VStack {
                    Text(title.rawValue)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Блокировка/лейблы
                    if !isUnlocked {
                        if isLegend && !isPremium {
                            // Показываем "Premium" и замок
                            HStack(spacing: 6) {
                                Text("Premium")
                                    .foregroundStyle(
                                        LinearGradient(colors: [.white, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .font(.caption.bold())
                            }
                        } else {
                            // Только замок
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
}

struct GlassMenuButton: View {
    var title: String
    var icon: String? = nil
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.title2.weight(.semibold))
                }
                
                Text(title)
                    .font(.title2.bold())
            }
            
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: 200, maxHeight: 60)
            .background(GlassProfileBackground(cornerRadius: 35))
            .clipShape(RoundedRectangle(cornerRadius: 35, style: .continuous))
            .shadow(color: Color.black.opacity(0.35), radius: 14, x: 0, y: 10)
            .shadow(color: Color.white.opacity(0.06), radius: 6, x: -2, y: -2)
        }
        .padding(.horizontal)
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

