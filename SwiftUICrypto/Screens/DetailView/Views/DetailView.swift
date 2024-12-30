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
    
    @StateObject private var vm: DetailViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20.0) {
                    overviewTitle
                    Divider()
                    overviewGrid
                    
                    additionalTitle
                    Divider()
                    additionalGrid
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
             navBarTrailingItem
            }
        })
    }
}

extension DetailView {
    
    private var navBarTrailingItem: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional information")
            .font(.title)
            .bold()
            .foregroundStyle(.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 30, content: {
            ForEach(vm.overviewStats) { stat in
                StatisticView(stats: stat)
            }
        })
    }
    
    private var additionalGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 30, content: {
            ForEach(vm.additionalStats) { stat in
                StatisticView(stats: stat)
            }
        })
    }
}

#Preview {
    NavigationView {
        DetailView(coin: MocPreview.coin)
    }
}
