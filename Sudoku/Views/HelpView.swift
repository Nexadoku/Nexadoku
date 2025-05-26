
import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    @State private var page = 0
    
    let steps: [HelpStep] = HelpStep.allSteps
    var body: some View {
        ZStack {
            SystemDarkBackground()
            VStack(spacing: 0) {
                TabView(selection: $page) {
                    ForEach(steps.indices, id: \.self) { idx in
                       
                            VStack(spacing: 12) {
                                Text(steps[idx].title)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                Text(steps[idx].description)
                                    .font(.system(size: 17))
                                    .foregroundColor(.white.opacity(0.92))
                                    .multilineTextAlignment(.center)
                                VStack(spacing: 24) {
                                    steps[idx].illustration
                                        .frame(height: 370)
                                        .padding(.top, 10)
                            }
                            .padding(.horizontal)
                        }
                        .tag(idx)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .padding(.vertical, 16)
                .animation(.easeInOut, value: page)
                
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .shadow(radius: 8)
                }
                .padding(.horizontal, 32)
                .padding(.top, 6)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct HelpPreviews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
