
import SwiftUI

struct PrivacyPolicy: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            SystemDarkBackground()
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        dismiss()
                        VibrationManager.shared.lightImpact()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .heavy))
                    }
                    
                    Text("PRIVACY POLICY")
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .heavy))
                        .lineLimit(3)
                    
                    Spacer()
                }
                .padding()
                
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(20)
                    .shadow(color: .purple.opacity(0.6), radius: 15, x: 0, y: 6)
                    .shadow(color: .indigo.opacity(0.4), radius: 10, x: 0, y: -4)
                    .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 16) {
                        Group {
                            Text("1. No Data Collection")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text("We do not collect, store, or share any personal data. All gameplay data is stored locally on your device.")
                            
                            Text("2. No Internet Connection Required")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text("The app works fully offline. It doesn't require or use an internet connection.")
                            
                            Text("3. Third-Party Services")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text("We do not use any third-party analytics, tracking, or advertising services.")
                            
                            Text("4. Children's Privacy")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text("The app does not collect anu information and is safe for all ages.")
                        }
                        
                        Group {
                            Text("5. Changes to This Policy")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text("We may update this Privacy Policy in the future. All changes will be displayed here.")

                            Text("6. Contact Us")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text("If you have any questions or concerns, please contact us through the support section of the app.")
                        }
                    }
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.black.opacity(0.3))
                            .blur(radius: 0.2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.purple.opacity(0.4), lineWidth: 0.5)
                            )
                    )
                    .padding(.horizontal)
                }
                Spacer()
            }
            .opacity(animate ? 1 : 0)
            .offset(y: animate ? 0 : 20)
            .animation(.easeOut(duration: 1.0).delay(0.2), value: animate)
        }
        .onAppear {
            animate = true
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PrivacyPolicy()
}
