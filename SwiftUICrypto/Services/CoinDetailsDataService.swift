//
//  CoinDetailsDataService.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 28.12.2024.
//

import Foundation
import Combine

final class CoinDetailsDataService {
    
    @Published var coinDetails: DetailCoinModel? = nil
    var coinDetailSubscription: AnyCancellable?
    
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinsDetails()
    }
    
    func getCoinsDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {return}
        
        coinDetailSubscription = NetworkManager.downloadData(for: url)
            .decode(type: DetailCoinModel.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Completion finished with error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] returnedCoinDetails in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailSubscription?.cancel()
            }
    }
}
