//
//  CoinDataService.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 09.07.2024.
//

import Foundation
import Combine

final class CoinDataService {
    
    @Published var allCoins: [Coin] = []
//    var cancellables = Set<AnyCancellable>()
    var coinSubscription: AnyCancellable? // здесь подписка на получение монет, чтобы потом было удобно отменить именно ее и не искать во множестве
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&per_page=250&sparkline=true&price_change_percentage=24h") else {return}
        
       coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default)) //меняет контекст выполнения на бэк поток
            .tryMap { (result) -> Data in
                    //проверяем данные
                guard let response = result.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                
                return result.data
            }
            .receive(on: DispatchQueue.main) //при получении переходим в main
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Completion decod finished with error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel() //отменяем подписку, она отработает один раз
            }
//            .store(in: &cancellables)
    }
}
