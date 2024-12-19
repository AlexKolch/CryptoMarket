//
//  PortfolioDataService.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 18.12.2024.
//

import Foundation
import CoreData

final class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entityName = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        //Загружаем наш контейнер
        container.loadPersistentStores { _, error in
            if let error {
                print("Error loading CoreData! \(error)")
            }
            self.getPortfolio()
        }
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        //проверяем монета уже сущ в БД или нет
        if let entity = savedEntities.first(where: {$0.coinID == coin.id}) {
            //если есть определяем обновляем ее данные или удаляем
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                remove(entity: entity)
            }
        } else {
            //создаем и сохр в базу
            add(coin: coin, amount: amount)
        }
    }
    
//MARK: - Private func
    
    ///получить сущности портфолио
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
           savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio entities - \(error)")
        }
    }
    
    ///Добавить новую сущность в контекст контейнера
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        //после того как мы создали эту сущность в контексте и обновили данные в сущности, нужно сохранить контекст
        applyChanges()
    }
    
    ///обновить существующую сущность
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    ///удалить сущность
    private func remove(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to CoreData - \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio() //так как БД не большая можно перезагрузить массив целиком, но если бы данных было много, лучше добавить нов сущность PortfolioEntity в массив savedPortfolioEntities
    }
}
