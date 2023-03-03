//
//  GeocodingCityModel.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/1/23.
//

import Foundation

/// The top-level model that represents the response from the Geocoding API.
struct GeocodingCityModel: Codable {
    var lat: Double
    var lon: Double
}
