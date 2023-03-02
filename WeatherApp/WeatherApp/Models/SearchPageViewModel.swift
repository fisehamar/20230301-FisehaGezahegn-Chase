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
    @Published var currentWeatherModel: CurrentWeatherModel?
    @Published var isLoading: Bool = false
    
    // MARK: - Init
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - View State
    
    func onAppear() {
        // TODO: Show the data of the last location searched.
    }
    
    func searchButtonTapped(_ searchInput: String) {
        guard !isLoading else { return }
        
        error = nil
        currentWeatherModel = nil
        isLoading = true
        networkService.getWeather(from: searchInput) { [weak self] error in
            self?.error = error
            self?.isLoading = false
        } successCompletion: { [weak self] forecastModel in
            self?.currentWeatherModel = forecastModel
            self?.isLoading = false
        }
    }
}
