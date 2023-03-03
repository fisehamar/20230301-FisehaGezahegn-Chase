//
//  GeocodingCityModelTests.swift
//  WeatherAppTests
//
//  Created by Fiseha Gezahegn on 3/2/23.
//

import XCTest
@testable import WeatherApp

final class GeocodingCityModelTests: WeatherAppTestCase {
    
    func testModelDoesParseWhenValidJSON() {
        // Given, When
        let response = parse(geocodingJson, toType: [GeocodingCityModel].self)
        // Then
        XCTAssertEqual(response?.first?.lon, -119.4432)
        XCTAssertEqual(response?.first?.lat, 36.4761)
    }
    
    
    func testModelDoesNotParseWhenInvalidJSON() {
        // Given, When
        let response = parse(invalidGeocodingJson, toType: [GeocodingCityModel].self)
        // Then
        XCTAssertNil(response)
    }
}
