//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/1/23.
//

import Combine
import Foundation

/// A generic protocol that handles the input and output for use with `NetworkService`.
protocol Service {
    /// The data that the service needs to create the URL.
    associatedtype Input
    /// The data to handle the parsing of the returned response after the API call.
    associatedtype Output: Codable
    var url: String { get }
}

/// Manages and creates network requests.
class NetworkService {
    
    // MARK: - Properties
    
    var cancellables = Set<AnyCancellable>()
    private let domain = "http://api.openweathermap.org"
    // For convenience but if given more time, it would be better in Keychain.
    private let appIdQuery = "&appid=905384a19171d60e489096cae5095bd2"
    
    // MARK: - Networking
    
    /// A generic network caller.
    /// - Parameter service: A service that conforms to `Service`.
    /// - Returns: A publisher that matches the output of the service.
    func call<S: Service>(_ service: S) -> AnyPublisher<S.Output, Error> {
        guard let url = URL(string: getFullUrl(service: service.url)) else {
            return Fail(error: NSError(domain: "Invalid URL.", code: 0)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .handleEvents(receiveSubscription: { subscription in
                print(subscription)
            })
            .receive(on: RunLoop.main)
            .catch({ error in
                Fail(error: error).eraseToAnyPublisher()
            })
            .map(\.data)
            .decode(type: S.Output.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func handleFailure(_ completion: Subscribers.Completion<Error>,
                       failureCompletion: @escaping (String) -> Void) {
        switch completion {
        case .failure(let error): failureCompletion(error.localizedDescription)
        default: break
        }
    }
    
    // MARK: - Private Methods
    
    private func getFullUrl(service: String) -> String {
        return domain + service + appIdQuery
    }
}
