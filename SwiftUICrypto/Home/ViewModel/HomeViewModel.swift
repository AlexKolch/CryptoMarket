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
    
    private let coinDataService = CoinDataService() //сервис получения данных о монетах
    private let marketDataService = MarketDataService() //сервис получения данных капитализации
    private let portfolioDataService = PortfolioDataService() //сервис загрузки данных из CoreData
    private var cancellables = Set<AnyCancellable>()
    
    init() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.allCoins.append(MocPreview.coin)
//            self.portfolioCoins.append(MocPreview.coin)
//        }
        addSubscibers()
    }
    
    ///создаются подписки на полученные монеты из API
    private func addSubscibers() {
        //        coinDataService.$allCoins
        //        //подписываемся на @Published var allCoins
        //            .sink { [weak self] coins in
        //                self?.allCoins = coins
        //            }
        //            .store(in: &cancellables) //Эта подписка больше не нужна, т к используем combineLatest ниже
        
        //MARK: - sink updates allCoins
        $searchText
        //объединяем с подпиской на dataService.$allCoins для использования двух значений searchText и [Coin] для фильтрации
            .combineLatest(coinDataService.$allCoins)
        //сделаем задержку, чтобы функция фильтрации не запускалась сразу же после ввода
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        //преобразуем вводимый текст в массив результата поиска
            .map { (inputText, allCoins) -> [CoinModel] in //после combineLatest мы имеем в параметрах вводимый текст и массив монет
                //если searchBar пустой, то возвращаем все монеты
                guard !inputText.isEmpty else {
                    return allCoins
                }
                
                //идет поиск/фильтрация в searchBar
                let searchingLowercasedText = inputText.lowercased() //преобразуем в нижний регистр для верной фильтрации
                let filteredCoins = allCoins.filter { coin in
                    //проверим есть ли такие названия в имени, символе или id
                    coin.name.lowercased().contains(searchingLowercasedText) || coin.symbol.lowercased().contains(searchingLowercasedText) || coin.id.lowercased().contains(searchingLowercasedText)
                }
                return filteredCoins
            }
        //синхронизируем массив allCoins с отфильтрованными монетами
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
        //сохраняем подписку
            .store(in: &cancellables)
        
        // MARK: - sink updates portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] coinsPortfolio in
                self?.portfolioCoins = coinsPortfolio
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
}
