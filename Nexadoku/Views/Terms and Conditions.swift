
import SwiftUI

struct TermsAndConditions: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            SystemBackground()
            VStack(spacing: 24) {
                HStack {
                    Button {
                        dismiss()
                        VibrationManager.shared.lightImpact()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                        
                        Text("Terms and Conditions")
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .heavy))
                            .bold()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
              
                Spacer()
                
                Text("You can read the full Terms and Conditions by tapping the button below.")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: openTerms) {
                    Text("View Terms and Conditions")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
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
