//
//  GeocodingService.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/2/23.
//

import Foundation

/// The service to get the geocoding that also manages the query values and response types.
struct GeocodingService: Service {
    
    typealias Input = String
    typealias Output = [GeocodingCityModel]
    var city: String
    
    var url: String {
        "/geo/1.0/direct?q=\(city)&limit=1"
    }
    
    init(_ city: Input) {
        self.city = city
    }
}

// Given more time, I would probably not extend it but instead encapuslate it into the service
// but doing this for network convenience.
extension NetworkService {
    /// A convenience method to retrieve the weather data in a single call using the city.
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
}
