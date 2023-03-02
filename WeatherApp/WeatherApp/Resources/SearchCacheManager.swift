//
//  SearchCacheManager.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/2/23.
//

import UIKit
import Foundation

struct SearchCacheManager {
    
    private let cityKey = "cityKey"
    
    func saveSearchQuery(_ city: String) {
        UserDefaults.standard.set(city, forKey: cityKey)
    }
    
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
