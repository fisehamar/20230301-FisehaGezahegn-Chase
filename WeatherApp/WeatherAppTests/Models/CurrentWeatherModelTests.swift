//
//  CurrentWeatherModelTests.swift
//  WeatherAppTests
//
//  Created by Fiseha Gezahegn on 3/2/23.
//

import XCTest
@testable import WeatherApp

class CurrentWeatherModelTests: WeatherAppTestCase {

    func testModelDoesParseWhenValidJSON() {
        // Given, When
        let response = parse(currentWeatherJson, toType: CurrentWeatherModel.self)
        // Then
        XCTAssertEqual(response?.name, "Zocca")
        XCTAssertEqual(response?.country, "IT")
        XCTAssertEqual(response?.humidity, "64")
        XCTAssertEqual(response?.temperature, "298.48")
        XCTAssertEqual(response?.windSpeed, "0.62")
        XCTAssertEqual(response?.weatherType, "Rain")
        XCTAssertEqual(response?.weatherDescription, "moderate rain")
        XCTAssertEqual(response?.weatherIcon, "10d")
    }
}
