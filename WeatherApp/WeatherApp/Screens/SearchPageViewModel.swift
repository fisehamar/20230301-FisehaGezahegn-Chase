//
//  SearchPageViewModel.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/1/23.
//

import Combine
import Foundation

class SearchPageViewModel {
    
    // MARK: - Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init() {
        //
    }
    
    // MARK: - Business
    
    func onAppear() {
        // TODO: Show the data of the last location searched.
    }
    
    func searchButtonTapped(_ searchInput: String) {
        guard let url = URL(string: "http://api.openweathermap.org/geo/1.0/direct?q=\(searchInput)&limit=1&appid=905384a19171d60e489096cae5095bd2") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [GeocodingCityModel].self, decoder: JSONDecoder())
            .compactMap { $0.first }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { data in
                let lat = data.lat
                let lon = data.lon
                guard let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=905384a19171d60e489096cae5095bd2") else { return }
                URLSession.shared.dataTaskPublisher(for: url)
                    .map(\.data)
                    .decode(type: FiveDayForecastModel.self, decoder: JSONDecoder())
                    .sink(receiveCompletion: { _ in },
                          receiveValue: { data in
                        print(data)
                    })
                    .store(in: &self.cancellables)
            })
            .store(in: &cancellables)
    }
}
