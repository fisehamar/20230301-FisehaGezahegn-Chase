//
//  FiveDayForecastModelTests.swift
//  WeatherAppTests
//
//  Created by Fiseha Gezahegn on 3/2/23.
//

import XCTest
@testable import WeatherApp

final class FiveDayForecastModelTests: WeatherAppTestCase {

    func testModelDoesParseWhenValidJSON() {
        // Given, When
        let response = parse(fiveDayForecastJson, toType: FiveDayForecastModel.self)
        // Then
        XCTAssertEqual(response?.city.name, "Zocca")
        XCTAssertEqual(response?.city.country, "IT")
        XCTAssertEqual(response?.days.first?.temperature, 73.0)
        XCTAssertEqual(response?.days.first?.weather.type, "Rain")
        XCTAssertEqual(response?.days.first?.weather.description, "light rain")
        XCTAssertEqual(response?.days.first?.weather.icon, "10d")
    }
    
    func testModelDoesNotParseWhenInvalidJSON() {
        // Given, When
        let response = parse(invalidFiveDayForecastJson, toType: FiveDayForecastModel.self)
        // Then
        XCTAssertNil(response)
    }
}
