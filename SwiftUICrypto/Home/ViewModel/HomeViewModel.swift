//
//  HomeViewModel.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 08.07.2024.
//

import Foundation

final class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.allCoins.append(MocPreview.coin)
            self.portfolioCoins.append(MocPreview.coin)
        }
    }
}
