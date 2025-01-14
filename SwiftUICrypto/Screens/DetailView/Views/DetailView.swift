//
//  DetailView.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 27.12.2024.
//

import SwiftUI
///for hack with lazy init detailView
//It hack was relevant till IOS 16 and NavigationStack resolved this problem by default
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
    @State private var showFullDescrpt: Bool = false
    
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
                    VStack(spacing: 8.0) {
                        overviewTitle
                        Divider()
                        descriptionText
                    }
                    
                    overviewGrid
                    
                    additionalTitle
                    Divider()
                    additionalGrid
                    
                    websiteSection
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
        .background(Color.myBackground.ignoresSafeArea())
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
    
    private var descriptionText: some View {
        ZStack {
            if let coinDescrpt = vm.descriptionCoin, !coinDescrpt.isEmpty {
                VStack {
                    Text(coinDescrpt)
                        .lineLimit(showFullDescrpt ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(.secondaryText)
                    HStack {
                        Spacer()
                        Button(showFullDescrpt ? "Less" : "Read more...") {
                            withAnimation(.easeInOut) {
                                showFullDescrpt.toggle()
                            }
                        }
                        .tint(.blue)
                        .font(.headline)
                        .padding(.vertical, 2)
                      
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
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
    
    private var websiteSection: some View {
        VStack(spacing: 20.0) {
            if let websiteString = vm.websiteURL,
               let url = URL(string: websiteString) {
                Link(destination: url, label: {
                    Text("Website")
                })
            }
            if let redditURL = vm.redditURL,
               let url = URL(string: redditURL) {
                Link(destination: url, label: {
                    Text("Reddit")
                })
            }
        }
        .tint(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationView {
        DetailView(coin: MocPreview.coin)
    }
}
