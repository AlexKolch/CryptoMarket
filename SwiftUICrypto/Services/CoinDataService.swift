//
//  CoinDataService.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 09.07.2024.
//

import Foundation
import Combine

final class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
//    var cancellables = Set<AnyCancellable>()
    /// здесь подписка на получение монет, чтобы потом было удобно отменить именно ее и не искать во множестве cancellables
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&per_page=250&sparkline=true&price_change_percentage=24h") else {return}
        
        coinSubscription = NetworkManager.downloadData(for: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main) //переходим в main после декодирования, так лучше для оптимизации
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Completion finished with error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel() //отменяем подписку, она отработает один раз
            }
//            .store(in: &cancellables)
    }
}
