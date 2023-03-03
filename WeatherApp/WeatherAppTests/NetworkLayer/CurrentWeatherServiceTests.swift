//
//  CurrentWeatherServiceTests.swift
//  WeatherAppTests
//
//  Created by Fiseha Gezahegn on 3/3/23.
//

import Combine
import XCTest
@testable import WeatherApp

final class CurrentWeatherServiceTests: WeatherAppTestCase {
    
    // MARK: - Properties
    
    private let lat = 20.0
    private let lon = 30.0
    
    // MARK: - Unit Tests
    
    func testUrlContainsCoordinates() {
        // Given
        let input = CurrentWeatherServiceInput(lat: lat, lon: lon)
        let service = CurrentWeatherService(input)
        // When
        let url = service.url
        // Then
        XCTAssertEqual(url, "/data/2.5/weather?lat=20.0&lon=30.0")
    }
}
