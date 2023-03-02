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
    
    init(_ input: Input) {
        city = input
    }
}
