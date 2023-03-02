//
//  SearchPageViewModel.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/1/23.
//

import Combine
import Foundation

class SearchPageViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private var networkService: NetworkService
    @Published var error: String?
    @Published var forecastModel: FiveDayForecastModel!
    
    // MARK: - Init
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - View State
    
    func onAppear() {
        // TODO: Show the data of the last location searched.
    }
    
    func searchButtonTapped(_ searchInput: String) {
        self.error = nil
        networkService.getWeather(from: searchInput) { error in
            self.error = error
        } successCompletion: { forecastModel in
            self.forecastModel = forecastModel
        }
    }
}
