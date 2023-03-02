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
