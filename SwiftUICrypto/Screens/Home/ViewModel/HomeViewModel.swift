//
//  HomeViewModel.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 08.07.2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService() //сервис получения данных о монетах
    private let marketDataService = MarketDataService() //сервис получения данных капитализации
    private let portfolioDataService = PortfolioDataService() //сервис загрузки данных из CoreData
    private var cancellables = Set<AnyCancellable>()
    
    ///параметры сортировки
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.allCoins.append(MocPreview.coin)
//            self.portfolioCoins.append(MocPreview.coin)
//        }
        addSubscibers()
    }
    
    ///создаются подписки на полученные монеты из API
    private func addSubscibers() {
//                coinDataService.$allCoins   //подписываемся на @Published var allCoins
//                    .sink { [weak self] coins in
//                        self?.allCoins = coins
//                    }
//                    .store(in: &cancellables) //Эта подписка больше не нужна, тк используем комбинированную combineLatest ниже
        
        //MARK: - sink updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption) //объединяем с другими Published для наблюдения трех значений
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) //делаем задержку map
            .map(filterAndSortCoins) //фильтрует и сортирует
        //подписываемся на полученные данные
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables) //сохраняем подписку
        
        // MARK: - sink updates portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] coinsPortfolio in
                guard let self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: coinsPortfolio)
            }
            .store(in: &cancellables)
        
        //MARK: - sink updates statistics
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStatsArray in
                self?.statistics = returnedStatsArray
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notify(type: .success) //устройство должно отдавать вибрацию
    }
}

private extension HomeViewModel {
    
    func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        // проверим есть ли в массиве allCoins монеты которые есть и в массиве savedEntities
        allCoins
            .compactMap { coin -> CoinModel? in
                //нам нужны монеты которые есть в портфеле(savedEntities), поэтому вернем nil если такой монеты нет и удалим из итогового массива
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else { return nil }
                return coin.updateHoldings(amount: entity.amount) //возвращаем монету типа CoinModel id которой есть в массиве [PortfolioEntity], при этом обновляя ее текущее кол-во в портфеле
            }
    }
    
    func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        //т.к. наша StatisticView работает с StatisticModel, преобразуем полученную MarketDataModel в нужную модель
        var stats = [StatisticModel]()
        
        guard let data = marketDataModel else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcMarketCap)
        
        //Расчет стоимости портфеля
        let porfolioValue =
        portfolioCoins
            .map({ $0.currentCostHoldings }) //получили массив значений стоимости каждой монеты
            .reduce(0, +) //получили сумму стоимости всего актива
        
        //Расчет предыдущей стоимости портфеля 24Н назад
        let previousValue =
        portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentCostHoldings
                let percentChange = (coin.priceChangePercentage24H ?? 0 / 100) / 100
                let previousValue = currentValue / (1 + percentChange) //получаем стоимость каждой монеты 24H назад
                return previousValue      //110 / (1 + 10%) = 100
            }
            .reduce(0, +)
        
        //Расчет изменения стоимости портфеля в %. ((Новое значение - старое значение) / старое значение) * 100
        let percentageChange = ((porfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: porfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }
    
    func filterCoins(inputText: String, coins: [CoinModel]) -> [CoinModel] {
        //если searchBar пустой, то возвращаем все монеты
        guard !inputText.isEmpty else {
            return coins
        }
        
        //идет поиск/фильтрация в searchBar
        let searchingLowercasedText = inputText.lowercased() //преобразуем в нижний регистр для верной фильтрации
        return coins.filter { coin in
            //проверим есть ли такие названия в имени, символе или id
            coin.name.lowercased().contains(searchingLowercasedText) || coin.symbol.lowercased().contains(searchingLowercasedText) || coin.id.lowercased().contains(searchingLowercasedText)
        }
    }
    
    func filterAndSortCoins(inputText: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var filteredCoins = filterCoins(inputText: inputText, coins: coins)
        sortCoins(sort: sort, coins: &filteredCoins)
        return filteredCoins
    }
    
    //работаем с сущ массивом через inout для лучшей скорости
    func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            return coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            return coins.sort(by: { $0.rank > $1.rank })
        case .price:
            return coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            return coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        //will only sort by holdings or revHold if needed
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentCostHoldings > $1.currentCostHoldings })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentCostHoldings < $1.currentCostHoldings })
        default:
            return coins
        }
    }
}
