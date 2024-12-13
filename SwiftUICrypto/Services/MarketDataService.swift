//
//  MarketDataService.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 13.12.2024.
//

import Foundation
import Combine

final class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    private func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubscription = NetworkManager.downloadData(for: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Completion MarketDataService finished with error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] returnedGlobalData in
                self?.marketData = returnedGlobalData.date
                self?.marketDataSubscription?.cancel()
            }
    }
}
