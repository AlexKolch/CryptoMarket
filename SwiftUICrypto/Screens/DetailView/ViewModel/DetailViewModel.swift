//
//  DetailViewModel.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 28.12.2024.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    
    @Published var overviewStats: [StatisticModel] = []
    @Published var additionalStats: [StatisticModel] = []
    
    @Published var coin: CoinModel
    private let coinDetailsService: CoinDetailsDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailsService = CoinDetailsDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailsService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistic)
            .sink { [weak self] returnedArrays in
                self?.overviewStats = returnedArrays.overview
                self?.additionalStats = returnedArrays.additional
            }
            .store(in: &cancellables)
    }
    
    ///преобразуем входящие типы в два отдельных массива; вернем в tuple
    private func mapDataToStatistic(detailCoinModel: DetailCoinModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
       
        let overviewArray = createOverviewArray(coin: coinModel)
        let additionalArray = createAdditionalArray(detailCoinModel: detailCoinModel, coinModel: coinModel)
        
        return (overviewArray, additionalArray)
    }
    
    private func createOverviewArray(coin: CoinModel) -> [StatisticModel] {
        //Цена
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coin.priceChangePercentage24H
        let priceOfStats = StatisticModel(title: "Current price", value: price, percentageChange: pricePercentChange)
        
        //Рыночная капитализация
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapOfStats = StatisticModel(title: "Market capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        //Ранжирование
        let rank = String(coin.rank)
        let rankOfStats = StatisticModel(title: "Rank", value: rank)
        
        //Объём
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeOfStats = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [priceOfStats, marketCapOfStats, rankOfStats, volumeOfStats]
        return overviewArray
    }
    
    private func createAdditionalArray(detailCoinModel: DetailCoinModel?, coinModel: CoinModel) -> [StatisticModel] {
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highOfStats = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowOfStats = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStats = StatisticModel(title: "24h price change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStats = StatisticModel(title: "24h Market cap change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = detailCoinModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block time", value: blockTimeString)
        
        let hashing = detailCoinModel?.hashingAlgorithm ?? "n/a"
        let hashingStats = StatisticModel(title: "Hashing algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [highOfStats, lowOfStats, priceChangeStats, marketCapChangeStats, blockStat, hashingStats]
        return additionalArray
    }
}
