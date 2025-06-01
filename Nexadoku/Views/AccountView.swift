import SwiftUI
import PhotosUI
import MessageUI

struct AccountView: View {
    @EnvironmentObject private var navigator: Navigator
    
    @State private var showMailView = false
    @State private var showMailError = false
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            SystemDarkBackground()
            ScrollView {
                VStack(spacing: 30) {
                    premiumButton(title: "Statistics", icon: "trophy.fill") {
                        navigator.push(.account(.statistics))
                        VibrationManager.shared.lightImpact()
                    }
                    
                    premiumSection(title: "SETTINGS AND PRIVACY") {
                        premiumButton(title: "Settings", icon: "gearshape.fill") {
                            navigator.push(.account(.settings))
                            VibrationManager.shared.lightImpact()
                        }
                        
                        premiumButton(title: "Privacy Policy", icon: "figure.child.and.lock.fill") {
                            navigator.push(.account(.aboutPremium))
                            VibrationManager.shared.lightImpact()
                        }
                    }
                    
                    premiumSection(title: "WE VALUE YOUR INPUT") {
                        Text("Got ideas, spotted a bug, or just want to share some thoughts? Let us know! Your feedback helps make Sudoku even better.")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.horizontal)
                        
                        premiumButton(title: "Send Feedback", icon: "paperplane.fill") {
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
                        
                        premiumButton(title: "Help", icon: "questionmark.circle.fill") {
                            navigator.push(.account(.help))
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


    // MARK: - Premium Button

    func premiumButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 30)
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.purple)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(LinearGradient(colors: [.purple.opacity(0.3), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.2)
                    )
                    .shadow(radius: 10)
            )
        }
        .padding(.horizontal)
    }
    
struct AccountViewPreviews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(Navigator())
            .environmentObject(LanguageSettings())
            .preferredColorScheme(.dark)
    }
}
