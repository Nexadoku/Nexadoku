
import SwiftUI

struct PrivacyPolicy: View {
    @Environment(\.dismiss) var dismiss

    @State private var animate = false

    var body: some View {
        ZStack {
            SystemBackground().ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    HStack {
                        Image(systemName: "figure.child.and.lock.fill")
                            .font(.system(size: 28, weight: .heavy))
                            .foregroundColor(.white)
                        
                        Text("Privacy Policy")
                            .font(.system(size: 28, weight: .heavy))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .padding()
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(20)
                        .shadow(color: .purple, radius: 15, x: 0, y: 6)
                        .padding(.top, 16)

                    VStack(alignment: .leading, spacing: 16) {
                        Group {
                            Text("1. Introduction")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("""
This Privacy Policy explains how we handle your information when you use the Nexadoku app (“the App”). By using the App, you agree to the terms described here.
""")
                            Text("2. Data Collection")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("""
• We do **not collect** or store any personal information.
• All game progress, settings, and stats are stored **locally** on your device and never leave your phone.
• No user analytics, tracking, or advertising SDKs are integrated.
""")
                            Text("3. In-App Purchases")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("""
• All purchases are handled by Apple’s In-App Purchase system.
• We do **not** access, collect, or store any payment information.
""")
                            Text("4. Internet & Connectivity")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("""
• The App works completely offline. Internet is not required for gameplay.
• No gameplay data or stats are sent to servers.
""")
                            Text("5. Children’s Privacy")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("""
• The app does not collect any data and is safe for all ages, including children under 13.
""")
                        }
                        Group {
                            Text("6. Data Security")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("""
• All your game data stays on your device.
• We recommend keeping your device secure with a passcode.
""")
                            Text("7. Changes to This Policy")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("""
• We may update this Privacy Policy from time to time.
• All updates will appear here in the app.
""")
                            Text("8. Contact Us")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("""
If you have any questions, please email us at:
futuresudoku@gmail.com
""")
                            Text("9. Compliance")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("""
• We comply with all Apple App Store requirements, including the End User License Agreement (EULA).
""")
                        }
                    }
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(colors: [.black.opacity(0.5), .purple.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                            )
                            .blur(radius: 0.2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.purple, lineWidth: 1)
                            )
                    )
                    .padding(.horizontal)
                }
                Spacer()
            }
            .opacity(animate ? 1 : 0)
            .offset(y: animate ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(0.08), value: animate)
        }
        .onAppear { animate = true }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                    VibrationManager.shared.lightImpact()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                    
                    Text("Back")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(.white)
                }
            }
        }
        .toolbarBackground(.purple.opacity(0.3), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    PrivacyPolicy()
}
