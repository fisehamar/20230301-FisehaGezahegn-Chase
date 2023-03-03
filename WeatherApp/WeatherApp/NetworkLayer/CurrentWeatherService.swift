//
//  FiveDayForecastService.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/2/23.
//

import Foundation

struct CurrentWeatherServiceInput {
    var lat: Double
    var lon: Double
}

/// The service to get the current weather that also manages the query values and response types.
struct CurrentWeatherService: Service {
    
    typealias Input = CurrentWeatherServiceInput
    typealias Output = CurrentWeatherModel
    var lat: Double
    var lon: Double
    
    var url: String {
        "/data/2.5/weather?lat=\(lat)&lon=\(lon)"
    }
    
    init(_ input: CurrentWeatherServiceInput) {
        lat = input.lat
        lon = input.lon
    }
}

// Given more time, I would probably not extend it but instead encapuslate it into the service
// but doing this for network convenience.
extension NetworkService {
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
