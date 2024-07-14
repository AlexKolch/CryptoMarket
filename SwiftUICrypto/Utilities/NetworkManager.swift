//
//  NetworkManager.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 10.07.2024.
//

import Foundation
import Combine

final class NetworkManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad response from URL: \(url)"
            case .unknown: return "[⚠️] Unknown error"
            }
        }
    }
    
    
    static func downloadData(for url: URL) -> AnyPublisher<Data, Error> {
       return URLSession.shared.dataTaskPublisher(for: url)
             .subscribe(on: DispatchQueue.global(qos: .default)) //меняет контекст выполнения на бэк поток
             .tryMap { (result) -> Data in //tryMap - преобразует данные в какой-либо тип
                     //проверяем данные
                 guard let response = result.response as? HTTPURLResponse,
                       response.statusCode >= 200 && response.statusCode < 300 else {
                     throw NetworkingError.badURLResponse(url: url)
                 }
                 
                 return result.data
             }
             .receive(on: DispatchQueue.main) //при получении переходим в main
             .eraseToAnyPublisher() //стирает длинный возвращаемый тип и делает его AnyPublisher
    }
}









