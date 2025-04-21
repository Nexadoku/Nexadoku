
import SwiftUI
import MessageUI

struct AccountView: View {
    @EnvironmentObject private var navigator: Navigator
    
    @State private var showMailView = false
    @State private var showMailError = false

    var body: some View {
        ZStack {
            SystemDarkBackground()

            ScrollView {
                VStack(spacing: 30) {
                    Text("account")
                        .font(.system(size: 42, weight: .black))
                        .foregroundStyle(.white)
                        .padding(.top, 40)

                    premiumSection(title: "GAME") {
                        premiumButton(title: "Statistics", icon: "trophy.fill") {
                            navigator.push(.account(.statistics))
                        }
                    }

                    premiumSection(title: "SETTINGS AND PRIVACY") {
                        premiumButton(title: "Settings", icon: "gearshape.fill") {
                            navigator.push(.account(.settings))
                        }

                        premiumButton(title: "Privacy Policy", icon: "figure.child.and.lock.fill") {
                            navigator.push(.account(.aboutPremium))
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
                            } else {
                                showMailError = true
                            }
                        }
                        .sheet(isPresented: $showMailView) {
                            MailView(
                                subject: "Sudoku App Feedback", recipients: ["support@murkami.com"], body: "Hi! I wanted to share the following feedback..."
                            )
                        }
                        .alert(isPresented: $showMailError) {
                            Alert(
                                title: Text("Email Not Available"),
                                message: Text("Please configure an email account in the Mail app to send feedback."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding(.bottom)
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
                            .stroke(LinearGradient(colors: [.white.opacity(0.3), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.2)
                    )
                    .shadow(color: .white.opacity(0.05), radius: 10, x: 0, y: 5)
            )
        }
        .padding(.horizontal)
    }
}

struct AccountViewPreviews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(Navigator())
            .environmentObject(LanguageSettings())
            .preferredColorScheme(.dark)
    }
}

