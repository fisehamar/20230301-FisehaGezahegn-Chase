//
//  SearchCacheManager.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/2/23.
//

import UIKit
import Foundation

// Given more time, it would be better to separate this into its different responsiblities
// rather than manage the UserDefaults and image caching.
struct SearchCacheManager {
    
    private let cityKey = "cityKey"
    
    /// Stores the search query into the `cityKey`.
    func saveSearchQuery(_ city: String) {
        UserDefaults.standard.set(city, forKey: cityKey)
    }
    
    /// Retrieves the string stored for `cityKey`.
    func loadSearchQuery() -> String? {
        UserDefaults.standard.string(forKey: cityKey)
    }
    
    func saveImage(image: UIImage, name: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as URL else {
            return false
        }
        
        do {
            try data.write(to: directory.appendingPathComponent("\(name).png"))
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
