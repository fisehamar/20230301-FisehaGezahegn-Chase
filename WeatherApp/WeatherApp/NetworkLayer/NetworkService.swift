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

class NetworkService {
    
    var cancellables = Set<AnyCancellable>()
    private let domain = "http://api.openweathermap.org"
    private let appIdQuery = "&appid=905384a19171d60e489096cae5095bd2"
    
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
    
    private func getFullUrl(service: String) -> String {
        return domain + service + appIdQuery
    }
}

/// For convenience. If I had more time, I would probabl encapsulate these requests/services into a separate
/// model instead of extending `NetworkService`.
extension NetworkService {
    
    /// A convenience method to retrieve the weather data in a single call.
    func getWeather(from city: String,
                    failureCompletion: @escaping (String) -> Void,
                    successCompletion: @escaping (CurrentWeatherModel) -> Void) {
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        call(GeocodingService(encodedCity))
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
    
    private func getWeather(from data: GeocodingCityModel,
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
    
    private func handleFailure(_ completion: Subscribers.Completion<Error>,
                               failureCompletion: @escaping (String) -> Void) {
        switch completion {
        case .failure(let error): failureCompletion(error.localizedDescription)
        default: break
        }
    }
}
