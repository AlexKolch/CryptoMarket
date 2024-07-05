//
//  Coin.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 05.07.2024.
//

import Foundation
/*
//https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&per_page=250&sparkline=true&price_change_percentage=24h
 
 JSON Response:
 {
         "ath": 73738,
         "ath_change_percentage": -24.42,
         "ath_date": "2024-03-14T07:10:36.635Z",
         "atl": 67.81,
         "atl_change_percentage": 82088.39531000001,
         "atl_date": "2013-07-06T00:00:00.000Z",
         "circulating_supply": 19719484.0,
         "current_price": 55589,
         "fully_diluted_valuation": 1170353708478,
         "high_24h": 58674,
         "id": "bitcoin",
         "image": "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
         "last_updated": "2024-07-05T13:47:32.926Z",
         "low_24h": 53898,
         "market_cap": 1098989106127,
         "market_cap_change_24h": -23874435146.40027,
         "market_cap_change_percentage_24h": -2.12621,
         "market_cap_rank": 1,
         "max_supply": 21000000.0,
         "name": "Bitcoin",
         "price_change_24h": -1551.791079733543,
         "price_change_percentage_24h": -2.71573,
         "price_change_percentage_24h_in_currency": -2.715732978526078,
         "roi": null,
         "sparkline_in_7d": {
             "price": [
                 61664.04237666266,
                 61243.68595983405,
             ]
         },
         "symbol": "btc",
         "total_supply": 21000000.0,
         "total_volume": 52188865479
}
 */

struct Coin: Identifiable, Decodable {
    let id: String
    let name: String
    let symbol: String
    let image: String
    let currentPrice: Double
    let ath, athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let circulatingSupply: Double?
    let fullyDilutedValuation: Double?
    let high24H: Double?
    let lastUpdated: String?
    let low24H: Double?
    let marketCap: Double?
    let marketCapChange24H, marketCapChangePercentage24H: Double?
    let marketCapRank: Double?
    let maxSupply: Double?
    let priceChange24H, priceChangePercentage24H, priceChangePercentage24HInCurrency: Double?
    let sparklineIn7D: SparklineIn7D?
    let totalSupply: Double?
    let totalVolume: Double?
    
    let currentCountHoldings: Double? //свои сохраненные монеты
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentCountHoldings
    }
    
    ///текущая стоимость активов
    var currentCostHoldings: Double {
        return (currentCountHoldings ?? 0) * currentPrice
    }
    
    ///рейтинг рыночной капитализации
    var rank: Int {
        return Int(marketCapRank ?? 0)
    }
    
    func updateHoldings(amount: Double) -> Coin {
        return Coin(id: id, name: name, symbol: symbol, image: image, currentPrice: currentPrice, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, circulatingSupply: circulatingSupply, fullyDilutedValuation: fullyDilutedValuation, high24H: high24H, lastUpdated: lastUpdated, low24H: low24H, marketCap: marketCap, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, marketCapRank: marketCapRank, maxSupply: maxSupply, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, sparklineIn7D: sparklineIn7D, totalSupply: totalSupply, totalVolume: totalVolume, currentCountHoldings: amount)
    }
}
struct SparklineIn7D: Decodable {
    let price: [Double]?
}
