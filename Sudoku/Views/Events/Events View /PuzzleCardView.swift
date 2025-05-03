
import SwiftUI

struct PuzzleCardView: View {
    let title: String
    let description: String
    let image: String
    let action: () -> Void

    var body: some View {
        ZStack {
            // Фон изображения с градиентом
            Image(image) // Изображение головоломки
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 250) // Высота карточки
                .cornerRadius(20)
                .clipped() // Обрезаем лишние части изображения
                .overlay(
                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]), startPoint: .top, endPoint: .bottom) // Градиент для темного фона
                        .cornerRadius(20)
                )

            VStack {
                // Текстовая информация
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white) // Белый цвет текста для контраста
                        .padding(.top, 15)
                        .padding(.leading, 20)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white) // Описание белым
                        .lineLimit(3)
                        .padding([.leading, .trailing])
                }

                Spacer() // Отделяем текст от кнопки

                // Кнопка внизу
                Button(action: action) {
                    Text("Start")
                        .font(.title3)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.purple)
                        .cornerRadius(20)
                        .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding([.leading, .trailing, .bottom])
                .background(Color.clear) // Чистая фоновая зона для кнопки
                .cornerRadius(20)
            }
        }
        .background(Color.white.opacity(0.05)) // Полупрозрачный фон для общей карточки
        .cornerRadius(20)
        .shadow(color: Color.purple, radius: 20, x: 0, y: 10)// Мягкая тень для премиум-эффекта
        .padding(.bottom)
        .scaleEffect(1.05) // Плавное увеличение при нажатии
        .animation(.spring(), value: 1) // Анимация при нажатии
    }
}

struct PuzzleCardView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleCardView(title: "Math Puzzle", description: "Solve interesting and challenging puzzles to test your math skills.", image: "your_image_name") {
            print("Start pressed")
        }
        .frame(width: 300, height: 250)
    }
}
