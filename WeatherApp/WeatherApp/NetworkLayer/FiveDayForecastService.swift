//
//  FiveDayForecastService.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/2/23.
//

import Foundation

struct FiveDayForecastServiceInput {
    var lat: Double
    var lon: Double
}

struct FiveDayForecastService: Service {
    
    typealias Input = FiveDayForecastServiceInput
    typealias Output = FiveDayForecastModel
    var lat: Double
    var lon: Double
    
    var url: String {
        "/data/2.5/forecast?lat=\(lat)&lon=\(lon)"
    }
    
    init(_ input: FiveDayForecastServiceInput) {
        lat = input.lat
        lon = input.lon
    }
}
