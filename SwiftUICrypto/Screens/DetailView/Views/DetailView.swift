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
    
    @StateObject var vm: DetailViewModel
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("init DetailView \(coin.name)")
    }
    
    var body: some View {
        Text("Hello")
    }
}

#Preview {
    DetailView(coin: MocPreview.coin)
}
