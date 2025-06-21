
import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    @State private var appearedSections: Set<Int> = []

    // Весь твой контент разбит на секции, каждый блок отдельно!
    let sections: [HelpSection] = [
        .init(
            icon: "sparkles",
            title: "Welcome to Nexadoku!",
            body: """
This isn’t just Sudoku — it’s your personal challenge, a source of fun, and the best way to become a logic master. Every element is designed for you to truly enjoy the game!

"""
        ),
        .init(
            icon: "pencil",
            title: "How to Play Sudoku",
            body: """
Sudoku is a logic game with a 9x9 grid. The goal: fill every cell with numbers 1-9 so that:
• Each row has unique numbers  
• Each column has unique numbers  
• Each 3x3 block has unique numbers

No math — just logic! Use pencil notes, analyze, don’t rush!
"""
        ),
        .init(
            icon: "square.grid.3x3.fill",
            title: "Interface Overview",
            body: """
- Grid — your main battlefield. This is where you enter numbers.
- Number Panel — select numbers to enter.
- Eraser — remove wrong/unneeded numbers.
- Pencil mode — make notes for possible values.
- Highlight — highlights all same numbers.
- Timer — race against yourself.
- Mistakes — error limit (if enabled).
"""
        ),
        .init(
            icon: "gear",
            title: "Quick Settings",
            body: """
Tap the ⚙️ (switch at the top) any time for instant access to settings:
- Sound, vibration, highlights, mistake limit, timer, premium features.
"""
        ),
        .init(
            icon: "trophy.fill",
            title: "Rewards & Points System",
            body: """
• Win games at every difficulty to earn trophies: Bronze, Silver, Gold.  
• Each trophy gives you points that track your progress.  
• Soon, you’ll be able to spend points on exclusive content!
"""
        ),
        .init(
            icon: "star.lefthalf.fill",
            title: "Difficulty Levels",
            body: """
• Easy — for beginners. Lots of hints, few empty cells.  
• Medium, Hard, Master, Epic, Legend — each one tougher than the last!  
• Each new level unlocks when you win enough games at the previous level.
"""
        ),
        .init(
            icon: "crown.fill",
            title: "Premium — Your Ticket to the Nexadoku Elite!",
            body: """
Premium isn’t just a purchase — it’s a lifestyle for true Sudoku fans:

• No ads: pure focus, no banners, no popups.  
• Exclusive trophies & rewards: achievements only for Premium players.  
• Legend level: the ultimate challenge, only for Premium.  
• Smart Highlight Lines: automatically show all matching rows/columns!  
• More personalization: themes, animations, icons (coming soon!)  
• Support: Your purchase fuels new features and events.

Premium = maximum fun, exclusivity, and helping Nexadoku grow.  
Try it once — you won’t want to play without it!
"""
        ),
        .init(
            icon: "heart.fill",
            title: "Why Go Premium?",
            body: """
- More fun: absolutely no ads, all features unlocked.
- Stand out: exclusive rewards are just for you.
- The future: support development for more updates and new content.
- Access the hardest levels and features.

Premium — your VIP pass to elite Sudoku!
"""
        ),
        .init(
            icon: "questionmark.bubble",
            title: "Frequently Asked Questions",
            body: """
Q: How do I unlock a new level?  
A: Win enough games on the previous level!

Q: Can I save my game?  
A: Absolutely! Just leave the game — your progress is saved automatically.

Q: How many hints per day?  
A: 3 hints daily.

Q: Is Premium forever?  
A: Yes! Buying once gives you lifetime access to all current premium features.
"""
        ),
        .init(
            icon: "flame.fill",
            title: "Pro Tips from a Sudoku Master",
            body: """
1. Start with cells with the fewest possibilities.
2. Don’t guess — analyze!
3. Use pencil mode if you’re unsure.
4. Premium highlights speed up your progress!
5. Earn trophies and spend points for exclusives — even more coming soon!
"""
        )
    ]

    var body: some View {
        ZStack {
            // Фон — можно добавить свои элементы или анимации
            ZStack {
               SystemBackground()
                .ignoresSafeArea()
                AnimatedGlows()
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 34) {
                    // Title
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                            
                            Text("HELP & GUIDE")
                                .font(.system(size: 32, weight: .heavy))
                                .foregroundStyle(LinearGradient(colors: [.white], startPoint: .top, endPoint: .bottom))
                        }
                        Spacer()
                    }
                    .padding(.horizontal)

                    ForEach(sections.indices, id: \.self) { idx in
                        HelpSectionCard(
                            section: sections[idx],
                            delay: Double(idx) * 0.10,
                            appeared: appearedSections.contains(idx)
                        )
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(idx) * 0.11) {
                                appearedSections.insert(idx)
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Всё, что ниже — как и в предыдущем примере, только для полноты:

struct AnimatedGlows: View {
    @State private var animate = false
    var body: some View {
        ZStack {
            ForEach(0..<3) { i in
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.purple.opacity(0.2), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 220 + CGFloat(i * 70), height: 160 + CGFloat(i * 80))
                    .blur(radius: 50)
                    .offset(x: CGFloat(i * 70) - 90, y: animate ? CGFloat(i * 90) + 60 : CGFloat(i * 40) + 20)
                    .opacity(0.7)
                    .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)
            }
        }
        .onAppear { animate = true }
    }
}

struct HelpSection: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let body: String
}

struct HelpSectionCard: View {
    let section: HelpSection
    var delay: Double
    var appeared: Bool

    @State private var expanded: Bool = true
    @Namespace private var animNS

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: section.icon)
                    .font(.system(size: 26))
                    .foregroundStyle(
                        LinearGradient(colors: [.white, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .shadow(color: .purple.opacity(0.5), radius: 6, y: 2)
                    .frame(width: 40, height: 40)
                    .background(.ultraThinMaterial.opacity(0.14))
                    .clipShape(Circle())

                Text(section.title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(LinearGradient(colors: [.white, .purple], startPoint: .leading, endPoint: .trailing))
                Spacer()
                Button {
                    withAnimation(.interactiveSpring(response: 0.50, dampingFraction: 0.83)) {
                        expanded.toggle()
                    }
                } label: {
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.trailing, 8)
                }
            }
            .padding(.top, 8)
            ZStack {
                if expanded {
                    Text(section.body)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.92))
                        .padding(.top, 2)
                        .padding(.bottom, 6)
                        .matchedGeometryEffect(id: "text\(section.id)", in: animNS)
                        .transition(.opacity)
                }
            }
            .frame(maxHeight: expanded ? .infinity : 0, alignment: .top)
            .opacity(expanded ? 1 : 0)
            .animation(.easeInOut(duration: 0.22), value: expanded)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(
                    LinearGradient(colors: [.purple.opacity(0.8), .white.opacity(0.22)], startPoint: .top, endPoint: .bottom),
                    lineWidth: 3
                )
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(LinearGradient(colors: [Color.black.opacity(0.74), Color.purple.opacity(0.18)], startPoint: .top, endPoint: .bottom))
                )
                .shadow(color: .purple.opacity(0.13), radius: 30, x: 0, y: 16)
        )
        .opacity(appeared ? 1 : 0)
        .scaleEffect(appeared ? 1 : 0.93)
        .animation(.spring(response: 0.7, dampingFraction: 0.77).delay(delay), value: appeared)
        .padding(.vertical, 2)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
            .preferredColorScheme(.dark)
    }
}
