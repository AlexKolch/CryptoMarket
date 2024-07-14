//
//  CoinImageService.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 13.07.2024.
//

import Foundation
import SwiftUI
import Combine
///логика загрузки изображения
final class CoinImageService {
    
    @Published var image: UIImage? = nil //сюда будем возвращать загруженную картинку
    
    private let coin: Coin
    private var imageSubscription: AnyCancellable?
    
    init(coin: Coin) {
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        guard let url = URL(string: coin.image) else {return}
        
        imageSubscription = NetworkManager.downloadData(for: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data) //преобразуем полученные данные в картинку
            })
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("getCoinImage finished with error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] returnedImage in //после преобразования данных через tryMap в картинку, можем работать с UIImage
                self?.image = returnedImage
                self?.imageSubscription?.cancel()
            }
    }
}
