
import SwiftUI

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct LuxuriousDarkBackgroundView: View {
    var body: some View {
        ZStack {
            // Темный градиент с глубокими металлическими оттенками (черный, угольно-серый, металлический)
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.indigo.opacity(0.7), Color.purple.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            // Добавление светящихся оттенков фиолетового для более роскошного ощущения
            RadialGradient(gradient: Gradient(colors: [Color.purple.opacity(0.5), Color.indigo.opacity(0.5)]), center: .center, startRadius: 20, endRadius: 300)
                .edgesIgnoringSafeArea(.all)
            
            // Эффект бокового освещения (как от фонаря) для создания атмосферности
            LinearGradient(gradient: Gradient(colors: [Color.indigo.opacity(1), Color.purple.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.all)
            
            // Легкое размытие для улучшения восприятия
            BlurView(style: .systemMaterialDark)
                .edgesIgnoringSafeArea(.all)
            
            ForEach(0..<50, id: \.self) { index in
                Text("\(Int.random(in: 1...9))")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(Color.gray.opacity(0.1))
                    .rotationEffect(.degrees(Double.random(in: 0...360)))
                    .position(x: CGFloat.random(in: 0...UIScreen.main.bounds.width), y: CGFloat.random(in: 0...UIScreen.main.bounds.height))
            }
            
            // Фокус на центре: световой эффект с переливом
            LinearGradient(gradient: Gradient(colors: [Color.indigo.opacity(0.1), Color.purple.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            // Текст для контраста с этим фоном
           
        }
    }
}

struct LuxuriousDarkBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        LuxuriousDarkBackgroundView()
    }
}
