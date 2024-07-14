//
//  CoinImageModel.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 14.07.2024.
//

import Foundation
import SwiftUI
import Combine
///логика настройки изображения
final class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil //картинка монеты
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    private let coin: Coin
    private let dataService: CoinImageService
    
    init(coin: Coin) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.isLoading = true
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.$image //подписываемся на полученную картинку
            .sink { [weak self] _ in
                //по завершению получения независимо от результата выкл статус загрузки
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
}
