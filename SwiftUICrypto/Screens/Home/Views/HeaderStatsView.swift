//
//  HeaderStatsView.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 12.12.2024.
//

import SwiftUI

struct HeaderStatsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(vm.statistics) { stat in
                StatisticView(stats: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortfolio ? .trailing : .leading)
    }
}

#Preview {
    HeaderStatsView(showPortfolio: .constant(false))
        .environmentObject(HomeViewModel())
}
