//
//  DetailViewModel.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 28.12.2024.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    
    private let coinDetailsService: CoinDetailsDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coinDetailsService = CoinDetailsDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailsService.$coinDetails
            .sink { returnedCoinDetails in
                print(returnedCoinDetails)
            }
            .store(in: &cancellables)
    }
}
