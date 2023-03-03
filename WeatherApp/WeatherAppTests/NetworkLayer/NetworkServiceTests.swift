//
//  NetworkServiceTests.swift
//  WeatherAppTests
//
//  Created by Fiseha Gezahegn on 3/3/23.
//

import XCTest
@testable import WeatherApp

final class NetworkServiceTests: XCTestCase {
    
    // MARK: - Properties
    
    private let cityName = "Dallas"
    private let lat = 20.0
    private let lon = 30.0
    
    // MARK: - Unit Tests
    
    func testFullUrlContainsGeocodingSegment() {
        // Given
        let networkService = NetworkService()
        let geocodingService = GeocodingService(cityName)
        // When
        let url = networkService.getFullUrl(service: geocodingService.url)
        // Then
        XCTAssertEqual(url, "http://api.openweathermap.org/geo/1.0/direct?q=Dallas&limit=1&appid=905384a19171d60e489096cae5095bd2")
    }
    
    func testFullUrlContainsCurrentWeatherSegment() {
        // Given
        let networkService = NetworkService()
        let currentWeatherService = CurrentWeatherService(.init(lat: lat, lon: lon))
        // When
        let url = networkService.getFullUrl(service: currentWeatherService.url)
        // Then
        XCTAssertEqual(url, "http://api.openweathermap.org/data/2.5/weather?lat=20.0&lon=30.0&appid=905384a19171d60e489096cae5095bd2")
    }
}
