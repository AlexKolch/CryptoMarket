//
//  HomeViewModel.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 08.07.2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var statistics = [
    StatisticModel(title: "Title", value: "Value", percentageChange: 1),
    StatisticModel(title: "Title", value: "Value"),
    StatisticModel(title: "Title", value: "Value"),
    StatisticModel(title: "Title", value: "Value", percentageChange: -1),
    ]
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService() //сервис получения монет
    private var cancellables = Set<AnyCancellable>()
    
    init() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.allCoins.append(MocPreview.coin)
//            self.portfolioCoins.append(MocPreview.coin)
//        }
        addSubscibers()
    }
    
    ///создается подписка на полученные монеты из API и обновляет локальную allCoins
    private func addSubscibers() {
//        coinDataService.$allCoins
//        //подписываемся на @Published var allCoins
//            .sink { [weak self] coins in
//                self?.allCoins = coins
//            }
//            .store(in: &cancellables) //Эта подписка больше не нужна, т к используем combineLatest ниже
        
        $searchText
        //объединяем с подпиской на dataService.$allCoins для использования двух значений searchText и [Coin] для фильтрации
            .combineLatest(coinDataService.$allCoins)
        //сделаем задержку, чтобы функция фильтрации не запускалась сразу же после ввода
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        //преобразуем вводимый текст в массив результата поиска
            .map { (inputText, allCoins) -> [CoinModel] in //после combineLatest мы имеем в параметрах вводимый текст и массив монет
                //если searchBar пустой, то возвращаем все монеты
                guard !inputText.isEmpty else {
                    return allCoins
                }
                
                //идет поиск/фильтрация в searchBar
                let searchingLowercasedText = inputText.lowercased() //преобразуем в нижний регистр для верной фильтрации
                let filteredCoins = allCoins.filter { coin in
                    //проверим есть ли такие названия в имени, символе или id
                    coin.name.lowercased().contains(searchingLowercasedText) || coin.symbol.lowercased().contains(searchingLowercasedText) || coin.id.lowercased().contains(searchingLowercasedText)
//                    coin.name.lowercased().contains(lowercasedText)
                }
                return filteredCoins
            }
        //синхронизируем массив allCoins с отфильтрованными монетами
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
        //сохраняем подписку
            .store(in: &cancellables)
    }
}
