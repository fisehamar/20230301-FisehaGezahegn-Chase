//
//  WeatherAppTestCase.swift
//  WeatherAppTests
//
//  Created by Fiseha Gezahegn on 3/2/23.
//

import XCTest

class WeatherAppTestCase: XCTestCase {
    
    let geocodingJson = "GeocodingJSON"
    let invalidGeocodingJson = "InvalidGeocodingJSON"
    let fiveDayForecastJson = "FiveDayForecastJSON"
    let invalidFiveDayForecastJson = "InvalidFiveDayForecastJSON"
    
    func parse<T: Codable>(_ filename: String, toType dataType: T.Type) -> T? {
        if let url = Bundle(for: type(of: self)).url(forResource: filename, withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let output = try? JSONDecoder().decode(dataType.self, from: data) {
            return output
        }
        return nil
    }
}
