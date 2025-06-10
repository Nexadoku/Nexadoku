
import SwiftUI

struct PointsAlert: View {
    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image("coin")
                .resizable()
                .frame(width: 100, height: 100)
                .shadow(color: .white, radius: 50)
            
            VStack(spacing: 5) {
                Text("What are Points?")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text("""
Earn points by unlocking trophies!

• Bronze Trophy: +10 points  
• Silver Trophy: +30 points  
• Gold Trophy: +60 points

Points are kept forever and show your progress.
""")
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .font(.body)
                .padding(.horizontal)
                
                Text("Coming soon: You’ll be able to spend points on exclusive content, customization, and more!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.body.weight(.medium))
            }
            
            Button(action: {
                           onClose()
                       }) {
                           Text("Close")
                               .font(.headline)
                               .foregroundColor(.white)
                               .frame(maxWidth: .infinity)
                               .padding()
                               .background(Color.indigo)
                               .cornerRadius(18)
                       }
                   }
                   .padding(.vertical, 34)
                   .padding(.horizontal, 28)
                   .background(
                       RoundedRectangle(cornerRadius: 35)
                           .fill(Color.purple)
                           .shadow(radius: 22)
                   )
                   .frame(maxWidth: 370)
                   .padding(.horizontal, 24)
                   .transition(.scale.combined(with: .opacity))
               }
           }
