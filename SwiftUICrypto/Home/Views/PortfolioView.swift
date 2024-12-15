//
//  PortfolioView.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 15.12.2024.
//

import SwiftUI

struct PortfolioView: View {
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
              Cover()
            }
        } else {
            NavigationView {
             Cover()
            }
        }
        
    }
}

struct Cover: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                SearchBarView(searchText: $vm.searchText)
               coinLogoList
              
            }
        }
        .navigationTitle("Edit Portfolio")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
               XMarkButton()

            }
        }
    }
    
}

extension Cover {
    private var coinLogoList: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(.vertical, 6)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin //при нажатии на монету присваиваем ее в переменную состояния
                            }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                            //если id нажатой монеты совпадает, сделать ей рамку
                                .stroke(selectedCoin?.id == coin.id ? .myGreen : .clear, lineWidth: 1)
                        }
                }
            }
            .offset(x: 8)
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    PortfolioView()
        .environmentObject(HomeViewModel())
}
