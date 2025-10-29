import SwiftUI
import PhotosUI
import MessageUI

struct AccountView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var storeManager: StoreManager
    
    @State private var showMailView = false
    @State private var showMailError = false
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            SystemBackground()
            ScrollView {
                VStack(spacing: 30) {
                    premiumSection(title: "") {
                        glassMenuButton(title: "Statistics", icon: "trophy.fill") {
                            navigator.push(.account(.statistics))
                            VibrationManager.shared.lightImpact()
                        }
                        
                        glassMenuButton(title: "Premium Membership", icon: "star.fill") {
                            navigator.push(.account(.premium))
                        }
                    }
                    premiumSection(title: "SETTINGS AND HELP") {
                        glassMenuButton(title: "Settings", icon: "gearshape.fill") {
                            navigator.push(.account(.settings))
                            VibrationManager.shared.lightImpact()
                        }
                        
                        glassMenuButton(title: "Help", icon: "questionmark.circle.fill") {
                            navigator.push(.account(.help))
                            VibrationManager.shared.lightImpact()
                        }
                    }
                    
                    premiumSection(title: "WE VALUE YOUR INPUT") {
                        Text("Got ideas, spotted a bug, or just want to share some thoughts? Let us know! Your feedback helps make Sudoku even better.")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.horizontal)
                        
                        glassMenuButton(title: "Send Feedback", icon: "paperplane.fill") {
                            if MFMailComposeViewController.canSendMail() {
                                showMailView = true
                                VibrationManager.shared.lightImpact()
                            } else {
                                showMailError = true
                                VibrationManager.shared.lightImpact()
                            }
                        }
                        
                        .sheet(isPresented: $showMailView) {
                            MailView(
                                subject: "Sudoku App Feedback", recipients: ["futuresudoku@gmail.com"], body: "Hi! I wanted to share the following feedback..."
                            )
                        }
                        .alert(isPresented: $showMailError) {
                            Alert(
                                title: Text("Email Not Available"),
                                message: Text("Please configure an email account in the Mail app to send feedback."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                        
                        glassMenuButton(title: "Privacy Policy", icon: "figure.child.and.lock.fill") {
                            navigator.push(.account(.privacyPolicy))
                        }
                        
                        glassMenuButton(title: "Terms And Conditions", icon: "text.document.fill") {
                            navigator.push(.account(.terms))
                        }
                        
                    }
                }
                .padding(.top)
            }
        }
    }
}
    
    // MARK: - Premium Section
    
    func premiumSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
                .padding(.horizontal)
            
            content()
        }
    }


    // MARK: - Glass Button (matches Menu)

    func glassMenuButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2.weight(.semibold))
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
            .background(GlassMenuBackground(cornerRadius: 25))
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .shadow(color: Color.black.opacity(0.35), radius: 14, x: 0, y: 10)
            .shadow(color: Color.white.opacity(0.06), radius: 6, x: -2, y: -2)
        }
        .padding(.horizontal)
    }

    struct GlassMenuBackground: View {
        var cornerRadius: CGFloat = 25
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.55),
                                Color(red: 60/255, green: 20/255, blue: 120/255).opacity(0.55)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(LinearGradient(colors: [Color.white.opacity(0.22), .clear], startPoint: .topLeading, endPoint: .center))
                    .blendMode(.screen)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(colors: [Color.white.opacity(0.8), Color.white.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1
                    )
            }
        }
    }
    
struct AccountViewPreviews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(Navigator())
            .environmentObject(LanguageSettings())
    }
}
