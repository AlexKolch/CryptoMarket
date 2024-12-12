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
    
    private let coin: CoinModel
    private let fileManager = LocalFileManager.shared
    private var imageSubscription: AnyCancellable?
    private let folderName: String = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(nameImage: imageName, nameFolder: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage() {
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
                guard let self, let returnedImage else { return }
                self.image = returnedImage
                self.imageSubscription?.cancel()
                self.fileManager.save(image: returnedImage, nameImage: imageName, nameFolder: folderName) //СОХРАНЯЕМ скаченные изображения в FileManager!
            }
    }
}
