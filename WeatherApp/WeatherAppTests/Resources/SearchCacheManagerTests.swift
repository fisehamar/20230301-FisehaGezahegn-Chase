//
//  SearchCacheManagerTests.swift
//  WeatherAppTests
//
//  Created by Fiseha Gezahegn on 3/2/23.
//

import XCTest
@testable import WeatherApp

final class SearchCacheManagerTests: WeatherAppTestCase {
    // MARK: - Properties
    
    private let city = "Dallas"
    
    // MARK: - Unit Tests
    
    func testSavedQueryIsNotNilWhenLoaded() {
        addTeardownBlock {
            UserDefaults.standard.removeObject(forKey: SearchCacheManager().cityKey)
        }
        
        // Given
        let manager = SearchCacheManager()
        // When
        manager.saveSearchQuery(city)
        // Then
        XCTAssertEqual(manager.loadSearchQuery(), city)
    }
    
    func testLoadedQueryIsNilWhenNotSaved() {
        // Given
        let manager = SearchCacheManager()
        // When
        UserDefaults.standard.removeObject(forKey: SearchCacheManager().cityKey)
        // Then
        XCTAssertNil(manager.loadSearchQuery())
    }
    
    func testSavedImageIsNotNilWhenLoaded() {
        // Given
        let manager = SearchCacheManager()
        // When
        let imageData = getDataForImage(imageName)
        XCTAssertNotNil(imageData)
        let savedImageUrl = manager.saveImage(data: imageData!, withName: imageName)
        // Then
        XCTAssertNotNil(manager.loadImage(name: imageName))
        
        // Teardown
        try? FileManager.default.removeItem(atPath: savedImageUrl)
    }
}
