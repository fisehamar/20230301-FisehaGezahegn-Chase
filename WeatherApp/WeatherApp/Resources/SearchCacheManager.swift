//
//  SearchCacheManager.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/2/23.
//

import UIKit
import Combine
import Foundation

// Given more time, it would be better to separate this into its different responsiblities
// rather than manage the UserDefaults and image caching.
class SearchCacheManager {
    
    var cancellables = Set<AnyCancellable>()
    private let cityKey = "cityKey"
    
    /// Stores the search query into the `cityKey`.
    func saveSearchQuery(_ city: String) {
        UserDefaults.standard.set(city, forKey: cityKey)
    }
    
    /// Retrieves the string stored for `cityKey`.
    func loadSearchQuery() -> String? {
        UserDefaults.standard.string(forKey: cityKey)
    }
    
    /// Downloads an image with the specified name and then saves it on device.
    /// Given more time, we would want to limit the amount of images saved, but the weather icons
    /// are very limited and small that there is hardly any size impact.
    /// Given more time this would be refactored into NetworkService to handle the image downloads.
    func saveImage(withName name: String) {
        [name]
            .publisher
            .compactMap { URL(string: "http://openweathermap.org/img/wn/" + $0 + "@2x.png") }
            .flatMap { URLSession.shared.dataTaskPublisher(for: $0) }
            .compactMap { $0.data }
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] data in
                guard let directory = self?.getLocalDirectory() else { return }
                do {
                    try data.write(to: directory.appendingPathComponent("\(name).png"))
                } catch {
                    print(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    
    func loadImage(name: String) -> UIImage? {
        if let directory = getLocalDirectory() {
            return UIImage(contentsOfFile: URL(fileURLWithPath: directory.absoluteString).appendingPathComponent(name).path)
        }
        return nil
    }
    
    private func getLocalDirectory() -> URL? {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            return nil
        }
        return directory
    }
}
