
import SwiftUI

struct StatsLineChart: View {
    let stats: GameStats
    @State private var progress: CGFloat = 0 // Для анимации

    var winDays: [Int] {
        stats.winsPerDayLast14Days()
    }
    var maxValue: Int { max(winDays.max() ?? 1, 1) }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height - 24

            let points: [CGPoint] = winDays.enumerated().map { idx, val in
                CGPoint(
                    x: width * CGFloat(idx) / CGFloat(max(winDays.count - 1, 1)),
                    y: height - CGFloat(val) / CGFloat(maxValue) * (height - 18) + 12
                )
            }

            ZStack {
                // Градиентное облако под линией
                if points.count > 1 {
                    Path { path in
                        path.move(to: CGPoint(x: points.first!.x, y: height + 12))
                        for (i, p) in points.enumerated() {
                            if i == 0 { path.addLine(to: p) }
                            else { path.addLine(to: CGPoint(x: p.x, y: p.y * progress + (1 - progress) * (height + 12))) }
                        }
                        path.addLine(to: CGPoint(x: points.last!.x, y: height + 12))
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(colors: [
                            Color.purple.opacity(0.23),
                            Color.indigo.opacity(0.11)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .animation(.easeOut(duration: 1.0), value: progress)
                }

                // Основная линия
                if points.count > 1 {
                    Path { path in
                        path.move(to: points.first!)
                        for p in points.dropFirst() {
                            path.addLine(to: CGPoint(x: p.x, y: p.y * progress + (1 - progress) * (height + 12)))
                        }
                    }
                    .stroke(
                        LinearGradient(
                            colors: [Color.purple, Color.indigo],
                            startPoint: .leading, endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                    )
                    .shadow(color: .purple.opacity(0.5), radius: 7, x: 0, y: 5)
                    .animation(.easeOut(duration: 1.0), value: progress)
                }

                // Точки
                ForEach(points.indices, id: \.self) { i in
                    Circle()
                        .fill(winDays[i] > 0 ? Color.purple : Color.gray.opacity(0.23))
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.75), lineWidth: winDays[i] > 0 ? 3 : 1)
                        )
                        .shadow(color: winDays[i] > 0 ? .purple.opacity(0.5) : .clear, radius: 7)
                        .scaleEffect(winDays[i] > 0 && progress > 0.8 ? 1.16 : 1)
                        .position(
                            x: points[i].x,
                            y: points[i].y * progress + (1 - progress) * (height + 12)
                        )
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.04 * Double(i)), value: progress)
                }
            }
            .onAppear {
                progress = 0
                withAnimation(.easeOut(duration: 1.0)) { progress = 1 }
            }
        }
        .frame(height: 120)
        .padding(.vertical, 8)
    }
}
