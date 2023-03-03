//
//  GeocodingServiceTests.swift
//  WeatherAppTests
//
//  Created by Fiseha Gezahegn on 3/3/23.
//

import Combine
import XCTest
@testable import WeatherApp

final class GeocodingServiceTests: WeatherAppTestCase {
    
    // MARK: - Properties
    
    private let citySpaceName = "St. Louis"
    
    // MARK: - Unit Tests
    
    func testUrlIsEncodedWhenSpaceInCity() {
        // Given
        let service = GeocodingService(citySpaceName)
        // When
        let url = service.url
        // Then
        XCTAssertEqual(url, "/geo/1.0/direct?q=St.%20Louis&limit=1")
    }
}
