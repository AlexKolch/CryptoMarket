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
    @State private var showSettingsView = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var isShowDetailView: Bool = false
    
    var body: some View {
        ZStack {
            // background layer
            Color.myBackground
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(vm)
                })
                .sheet(isPresented: $showSettingsView, content: {
                    SettingsView()
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
        .background {
            //ссылка активируется при переключении @State isShowDetailView
            NavigationLink(
                destination: LoadingDetailView(coin: $selectedCoin),
                isActive: $isShowDetailView,
                label: { EmptyView() })
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
                    } else {
                        showSettingsView.toggle()
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
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank //меняем состояние сортировки на противоположное
                }
            }
            
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            //BUTTON UPDATE
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
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
                    .onTapGesture {
                        didTap(on: coin)
                    }
            }
        }
        .listStyle(.plain)
        .refreshable {
            vm.reloadData()
        }
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
    
    private func didTap(on coin: CoinModel) {
        selectedCoin = coin
        isShowDetailView.toggle()
    }
    
}
