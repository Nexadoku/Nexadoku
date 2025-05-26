
import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss

    let steps: [HelpStep] = HelpStep.allSteps
    @State private var page = 0

    var body: some View {
        ZStack {
            SystemDarkBackground()
            VStack(spacing: 0) {
                TabView(selection: $page) {
                    ForEach(Array(steps.enumerated()), id: \.offset) { idx, step in
                        VStack(spacing: 16) {
                            Text(step.title)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 6)
                            if let topImage = step.topImage {
                                topImage
                                    .frame(height: 56)
                            }
                            if let topText = step.topText {
                                Text(topText)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.92))
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 6)
                            }
                            if let bottomText = step.bottomText {
                                Text(bottomText)
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.85))
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 2)
                            }
                        }
                        .padding(.horizontal, 18)
                        .tag(idx)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .padding(.vertical, 10)
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
                .padding(.top, 8)
                .padding(.bottom, 16)
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
