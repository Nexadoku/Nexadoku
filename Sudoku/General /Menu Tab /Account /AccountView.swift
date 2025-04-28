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
    
    @State private var showBannerActionSheet = false
    @State private var showAvatarActionSheet = false
    
    @AppStorage("nickname") private var nickname: String = "Your Nickname"
    @State private var isEditingNickname = false
    
    @AppStorage("avatarImagePath") private var avatarImagePath: String?
    @AppStorage("bannerImagePath") private var bannerImagePath: String?
    
    var body: some View {
        ZStack {
            SystemDarkBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    
                    ZStack(alignment: .bottomLeading) {
                        Button {
                            showBannerActionSheet = true
                            VibrationManager.shared.lightImpact()
                        } label: {
                            ZStack {
                                if let banner = bannerImage {
                                    Image(uiImage: banner)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .clipped()
                                } else {
                                    Color.purple.opacity(0.25)
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
                                showAvatarActionSheet = true
                                VibrationManager.shared.lightImpact()
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
                                VibrationManager.shared.lightImpact()
                            } else {
                                showMailError = true
                                VibrationManager.shared.lightImpact()
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
            .ignoresSafeArea()
        }
        .customActionSheet(isPresented: $showBannerActionSheet, title: "Banner") {
            clearBannerImage()
        } onChange: {
            showBannerPicker = true
        }
        .customActionSheet(isPresented: $showAvatarActionSheet, title: "Avatar") {
            clearAvatarImage()
        } onChange: {
            showAvatarPicker = true
        }
        .onAppear {
            loadSavedImage()
        }
        .onChange(of: avatarImage) { newImage in
            if let newImage = newImage {
                if let oldPath = avatarImagePath {
                    deleteImage(at: oldPath)
                }
                avatarImagePath = saveImage(newImage)
            }
        }
        .onChange(of: bannerImage) { newImage in
            if let newImage = newImage {
                if let oldPath = bannerImagePath {
                    deleteImage(at: oldPath)
                }
                bannerImagePath = saveImage(newImage)
            }
        }
    }
    
    // MARK: - Save / Load / Delete Images
    
    func saveImage(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return nil }
        let filename = UUID().uuidString + ".jpg"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        do {
            try data.write(to: url)
            return url.path
        } catch {
            print("Error saving image:", error)
            return nil
        }
    }

    func loadSavedImage() {
        if let avatarPath = avatarImagePath {
            avatarImage = loadImage(from: avatarPath)
        }
        if let bannerPath = bannerImagePath {
            bannerImage = loadImage(from: bannerPath)
        }
    }

    func loadImage(from path: String) -> UIImage? {
        let url = URL(fileURLWithPath: path)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }

    func deleteImage(at path: String) {
        let url = URL(fileURLWithPath: path)
        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    func clearBannerImage() {
        if let oldPath = bannerImagePath {
            deleteImage(at: oldPath)
        }
        
        bannerImagePath = nil
        bannerImage = nil
    }
    
    func clearAvatarImage() {
        if let oldPath = avatarImagePath {
            deleteImage(at: oldPath)
        }
        avatarImagePath = nil
        avatarImage = nil
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

extension View {
    func customActionSheet(
        isPresented: Binding<Bool>,
        title: String,
        onDelete: @escaping () -> Void,
        onChange: @escaping () -> Void
    ) -> some View {
        self.overlay(
            Group {
                if isPresented.wrappedValue {
                 
                        ZStack {
                            Color.black.opacity(0.4)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation {
                                        isPresented.wrappedValue = false
                                    }
                                }
                            
                            VStack(spacing: 20) {
                                Text("Manage \(title)")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Button(action: {
                                    withAnimation {
                                        onChange()
                                        isPresented.wrappedValue = false
                                    }
                                }) {
                                    Text("Choose Photo")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            LinearGradient(
                                                colors: [Color.black.opacity(0.6), Color.purple.opacity(0.6)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .stroke(.purple, lineWidth: 3)
                                            )
                                            .cornerRadius(25)
                                        )
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        onDelete()
                                        isPresented.wrappedValue = false
                                    }
                                }) {
                                    Text("Delete Photo")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.red)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            LinearGradient(
                                                colors: [Color.black.opacity(0.6), Color.purple.opacity(0.6)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .stroke(.purple, lineWidth: 3)
                                            )
                                            .cornerRadius(25)
                                        )
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        isPresented.wrappedValue = false
                                    }
                                }) {
                                    Text("Cancel")
                                        .font(.system(size: 18, weight: .regular))
                                        .foregroundColor(.white.opacity(0.8))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                            }
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color.black.opacity(0.3), Color.purple.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(.purple, lineWidth: 3)
                                )
                                .cornerRadius(25)
                                .shadow(color: .black, radius: 20)
                            )
                            .frame(width: 300)
                    }
                        .transition(.opacity)
                        .background(SystemDarkBackground())
                }
            }
        )
    }
}

