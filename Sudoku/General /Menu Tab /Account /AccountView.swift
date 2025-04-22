
import SwiftUI
import MessageUI

struct AccountView: View {
    @EnvironmentObject private var navigator: Navigator
    
    @State private var showMailView = false
    @State private var showMailError = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var draftImage: UIImage? = nil
    @State private var draftUserName: String = "@sudoku.master"
    @State private var isEditingName = false
    @State private var userName: String = ""
    
    let imageFileName = "profileImage.png"
    
    var body: some View {
        ZStack {
            SystemDarkBackground()

            ScrollView {
                VStack(spacing: 30) {
                    Text("account")
                        .font(.system(size: 42, weight: .black))
                        .foregroundStyle(.white)
                        .padding(.top, 40)
                    
                    premiumProfileSection()
                    
                    
                        premiumButton(title: "Statistics", icon: "trophy.fill") {
                            navigator.push(.account(.statistics))
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
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(isPresented: $showImagePicker, selectedImage: $draftImage)
        }
        .onAppear {
            loadUserData()
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
    
    func premiumProfileSection() -> some View {
            HStack(spacing: 15) {
                if isEditingName {
                    Button(action: {
                        showImagePicker.toggle()
                    }) {
                        if let draftImage = draftImage {
                            Image(uiImage: draftImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .foregroundColor(.gray)
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    if isEditingName {
                        TextField("Enter your nickname", text: $draftUserName)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top, 5)
                    } else {
                        Text(userName)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.leading, 10)

                Spacer()

                Button(action: {
                    if isEditingName {
                        // Save changes
                       saveUserData()
                    } else {
                        // Start editing, init temp values
                        draftUserName = userName
                        draftImage = selectedImage
                    }
                    isEditingName.toggle()
                }) {
                    Text(isEditingName ? "Save" : "Edit")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 15)
                        .background(Color.purple)
                        .cornerRadius(15)
                }
                .padding(.trailing, 10)
            }
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [.purple, .indigo]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .cornerRadius(15)
            )
            .padding(.horizontal)
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
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
    
    func saveUserData() {
        userName = draftUserName
        selectedImage = draftImage
        
        UserDefaults.standard.set(userName, forKey: "userName")
        
        if let image = selectedImage,
           let data = image.pngData() {
            let url = getDocumentsDirectory().appendingPathComponent(imageFileName)
            try? data.write(to: url)
        }
    }
    
    func loadUserData() {
        userName = UserDefaults.standard.string(forKey: "userName") ?? "@sudoku.master"
        draftUserName = userName
        
        let url = getDocumentsDirectory().appendingPathComponent(imageFileName)
        if let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            selectedImage = image
            draftImage = image
        }
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
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

