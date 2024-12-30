//
//  ChartView.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 30.12.2024.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double] //здесь данные о ценнах за промежуток времени
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startDate: Date
    private let endDate: Date
    @State private var percentage: CGFloat = 0.0
    
    init(coin: CoinModel) {
        self.data = coin.sparklineIn7D?.price ?? [] //те самые данные из модели
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        self.lineColor = priceChange > 0 ? .myGreen : .myRed
        
        self.endDate = Date(coinDate: coin.lastUpdated ?? "")
        self.startDate = endDate.addingTimeInterval(-7*24*60*60) //в секундах измеряется TimeInterval. 7 дней назад
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBG)
                .overlay(alignment: .leading) { chartYAxis.padding(.horizontal, 4) }
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundStyle(.secondaryText)
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        })
    }
}

#Preview {
    ChartView(coin: MocPreview.coin)
//        .frame(width: 200)
}

private extension ChartView {
    
    var chartView: some View {
        GeometryReader { geo in //получаем геометрию контейнера в котором находится Chart. Чтобы размеры chart были динамическими
            Path { path in
                for index in data.indices {
                    // 300 - ширина экрана. 100 - data.count
                    // 300 / 100 = 3
                    // (index + 1) * 3 = 3; 2 * 3 = 6; 100 * 3 = 300 - x меняется от 3 до 300
                    
                    let xPosition = geo.size.width / CGFloat(data.count) * CGFloat(index + 1) //рассчет позиции по X
                    
                    //100,000 - max
                    //97,000 - min
                    //100,000 - 97,000 = 3,000 - разница диапозона по yAxis
                    //99,000 - data point
                    //99,000 - 97,000 = 2,000 / 3,000 = 66,6% прибыль. data point находится на 66,6% выше минимальной точки
                    
                    let yAxis = maxY - minY
                    let yPosition = (1 - (data[index] - minY) / yAxis) * geo.size.height //сист координат айфона по y противоположная стандартной, поэтому нужно из 1 вычесть % чтобы перевернуть ось Y
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition)) //исходное положение
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0.0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0.0, y: 5.0)
            .shadow(color: lineColor.opacity(0.5), radius: 12, x: 0.0, y: 10.0)
            .shadow(color: lineColor.opacity(0.2), radius: 12, x: 0.0, y: 20.0)
            .shadow(color: lineColor.opacity(0.1), radius: 12, x: 0.0, y: 30.0)
        }
    }
    
    var chartBG: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    var chartDateLabels: some View {
        HStack {
            Text(startDate.asShortDateString())
            Spacer()
            Text(endDate.asShortDateString())
        }
    }
    
    var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            let severalPrice = (maxY + minY) / 2
            Text(severalPrice.formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
}
