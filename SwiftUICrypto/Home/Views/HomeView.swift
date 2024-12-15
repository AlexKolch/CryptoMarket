//
//  HomeView.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 05.07.2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio = false //animate right
    @State private var showPortfolioView = false //display sheet
    
    var body: some View {
        ZStack {
            // background layer
            Color.myBackground
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(vm)
                })
            
            ///content layer
            VStack {
                homeHeader
                
                HeaderStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                
                columnTitles
                
                //List
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                } else {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarHidden(true)
    }.environmentObject(HomeViewModel())
}

private extension HomeView {
    
    var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .transaction { transaction in
                    transaction.animation = nil
                }
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                }
                .background {
                    AnimateCircleView(isAnimate: $showPortfolio)
                }
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Current prices")
                .font(.headline).fontWeight(.heavy).foregroundStyle(.accent)
                .transaction { transaction in
                    transaction.animation = nil
                }
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    var columnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Text("Price").frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundStyle(.secondaryText)
        .padding(.horizontal)
    }
    
    var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
    var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
}
