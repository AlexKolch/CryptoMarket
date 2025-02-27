//
//  MarketDataService.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 13.12.2024.
//

import Foundation
import Combine

final class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil //сюда придут данные из API
    
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
      
        marketDataSubscription = NetworkManager.downloadData(for: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Completion MarketDataService finished with error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] returnedGlobalData in
            
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            }
    }
}
