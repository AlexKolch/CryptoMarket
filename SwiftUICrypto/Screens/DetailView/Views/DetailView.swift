//
//  DetailView.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 27.12.2024.
//

import SwiftUI
///for hack with lazy init detailView
struct LoadingDetailView: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        print("init view \(coin.name)")
    }
    
    var body: some View {
        Text(coin.name)
    }
}

#Preview {
    DetailView(coin: MocPreview.coin)
}
