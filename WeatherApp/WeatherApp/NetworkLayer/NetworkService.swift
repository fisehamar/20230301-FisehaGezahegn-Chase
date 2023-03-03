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

    func getFullUrl(service: String) -> String {
        return domain + service + appIdQuery
    }
    
    // MARK: - Service Calls
    // If given more time, I would not include the services here, but encapsulate them elsewhere.
    // The reason I put them in here is for convenience use and also ease of use in faster unit testing
    // by overriding the methods. Otherwise a better approach would be to use protocols and then
    // in the unit tests assign the values we want, but we would have to rewrite some of the NetworkLayer.
    
    /// A convenience method to retrieve the weather data in a single call using the city.
    func getWeather(from city: String,
                    failureCompletion: @escaping (String) -> Void,
                    successCompletion: @escaping (CurrentWeatherModel) -> Void) {
        call(GeocodingService(city))
            .handleEvents(receiveSubscription: { subscription in
                print(subscription)
            })
            .compactMap { $0.first }
            .sink { completion in
                self.handleFailure(completion, failureCompletion: failureCompletion)
            } receiveValue: { [weak self] data in
                self?.getWeather(from: data, failureCompletion: failureCompletion, successCompletion: successCompletion)
            }
            .store(in: &cancellables)
    }
    
    /// A convenience method to retrieve the weather data using coordinates.
    func getWeather(from data: GeocodingCityModel,
                    failureCompletion: @escaping (String) -> Void,
                    successCompletion: @escaping (CurrentWeatherModel) -> Void) {
        call(CurrentWeatherService(.init(lat: data.lat, lon: data.lon)))
            .handleEvents(receiveSubscription: { subscription in
                print(subscription)
            })
            .sink { [weak self] completion in
                self?.handleFailure(completion, failureCompletion: failureCompletion)
            } receiveValue: { data in
                successCompletion(data)
            }
            .store(in: &cancellables)
    }
}
