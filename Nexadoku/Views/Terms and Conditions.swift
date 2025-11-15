
import SwiftUI

struct TermsAndConditions: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            SystemBackground()
            VStack(spacing: 24) {
                HStack {
                    Image(systemName: "text.document.fill")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(.white)
                    
                    Text("Terms And Conditions")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                
                Text("You can read the full Terms and Conditions by tapping the button below.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: openTerms) {
                    Text("View Terms and Conditions")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 140/255, green: 60/255, blue: 255/255))
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
        }
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
        .toolbarBackground(Color(red: 140/255, green: 60/255, blue: 255/255).opacity(0.3), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    private func openTerms() {
        if let url = URL(string: "https://taplink.cc/nexadoku.terms") {
            UIApplication.shared.open(url)
        }
    }
}

struct TermsAndConditions_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditions()
    }
}
