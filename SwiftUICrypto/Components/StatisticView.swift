//
//  StatisticView.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 12.12.2024.
//

import SwiftUI

struct StatisticView: View {
    
    let stats: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Text(stats.title)
                .font(.caption)
                .foregroundStyle(.secondaryText)
            Text(stats.value)
                .font(.headline)
                .foregroundStyle(.accent)
            //Percentage change info
            HStack(spacing: 4.0) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (stats.percentageChange ?? 0) >= 0 ? 0 : 180))
                    
                Text(stats.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle((stats.percentageChange ?? 0) >= 0 ? .myGreen : .myRed)
            .opacity(stats.percentageChange == nil ? 0.0 : 1.0) ///использую opacity чтобы все переиспользуемые блоки имели одинаковый frame, если не будет значения в HStack мы его просто не увидим
        }
    }
}

#Preview {
    StatisticView(stats: StatisticModel(title: "Market Cap", value: "$12.58n", percentageChange: 25.34))
}

