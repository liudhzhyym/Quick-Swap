//
//  CurrencyService.swift
//  QuickSwap
//
//  Created by Piotr Szadkowski on 10/07/2020.
//

import Foundation
import Combine

final class CurrencyService {
    
    private let session: URLSession
    
    enum CurrencyServiceError: Error {
        case invalidBase
        case urlError
        
        init(urlError: URLError) {
            print(urlError)
            self = .urlError
        }
    }
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchCurrencies(for base: String) -> AnyPublisher<CurrencyConversion, Error> {
        return session.dataTaskPublisher(for: components(for: base).url!)
            .mapError { CurrencyServiceError.init(urlError: $0) }
            .map { $0.data }
            .decode(type: CurrencyConversion.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func components(for base: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.exchangeratesapi.io"
        components.path = "/latest"
        components.queryItems = [URLQueryItem(name: "base", value: base)]
        return components
    }
    
}
