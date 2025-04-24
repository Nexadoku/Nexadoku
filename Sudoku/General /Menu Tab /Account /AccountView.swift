import SwiftUI
import PhotosUI
import MessageUI

struct AccountView: View {
    @EnvironmentObject private var navigator: Navigator
    
    @State private var showMailView = false
    @State private var showMailError = false
    
    @State private var bannerImage: UIImage? = nil
    @State private var avatarImage: UIImage? = nil
    
    @State private var showBannerPicker = false
    @State private var showAvatarPicker = false
    
    @AppStorage("nickname") private var nickname: String = "Your Nickname"
    @State private var isEditingNickname = false
    
    var body: some View {
        ZStack {
            SystemDarkBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    
                    ZStack(alignment: .bottomLeading) {
                        Button {
                            showBannerPicker = true
                        } label: {
                            ZStack {
                                if let banner = bannerImage {
                                    Image(uiImage: banner)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .clipped()
                                } else {
                                    Color.gray.opacity(0.25)
                                    VStack {
                                        Image(systemName: "photo.on.rectangle")
                                            .font(.system(size: 30))
                                            .foregroundColor(.white.opacity(0.6))
                                        Text("Tap to select banner")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .clipped()
                            .contentShape(Rectangle())
                        }
                        .sheet(isPresented: $showBannerPicker) {
                            ImagePicker(image: $bannerImage)
                        }
                        
                        HStack(alignment: .bottom, spacing: 16) {
                            Button {
                                showAvatarPicker = true
                            } label: {
                                ZStack {
                                    if let avatar = avatarImage {
                                        Image(uiImage: avatar)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } else {
                                        Circle()
                                            .fill(Color.gray.opacity(0.3))
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.white.opacity(0.6))
                                            .font(.system(size: 40))
                                    }
                                }
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                            }
                            .sheet(isPresented: $showAvatarPicker) {
                                ImagePicker(image: $avatarImage)
                            }
                            .offset(x: 16, y: 45)
                            
                            HStack {
                                if isEditingNickname {
                                    TextField("Enter nickname", text: $nickname)
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.white)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(8)
                                        .padding(.trailing, 4)
                                    
                                    Button(action: {
                                        isEditingNickname = false
                                        VibrationManager.shared.lightImpact()
                                    }) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.green)
                                    }
                                } else {
                                    Text(nickname)
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Button(action: {
                                        isEditingNickname = true
                                        VibrationManager.shared.lightImpact()
                                    }) {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                            }
                            .padding(.leading, 8)
                            .offset(y: 45)
                        }
                    }
                    .padding(.bottom, 45)
                    
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
    
struct AccountViewPreviews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(Navigator())
            .environmentObject(LanguageSettings())
            .preferredColorScheme(.dark)
    }
}

