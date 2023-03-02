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
    private var searchCacheManager: SearchCacheManager
    @Published var error: String?
    @Published var currentWeatherModel: CurrentWeatherModel?
    @Published var isLoading: Bool = false
    
    // MARK: - Init
    
    init(networkService: NetworkService = NetworkService(),
         searchCacheManager: SearchCacheManager = SearchCacheManager()) {
        self.networkService = networkService
        self.searchCacheManager = searchCacheManager
    }
    
    // MARK: - View State
    
    func onAppear() {
        // Request user permission. If user agrees, get the current location and pass the city to the getWeather(with:) method.
        // If they DENY location, use the previously stored result.
        if let previousCity = searchCacheManager.loadSearchQuery() {
            getWeather(with: previousCity)
        }
        // If there is isn't anything, do nothing.
    }
    
    func searchButtonTapped(_ searchInput: String) {
        guard !isLoading else { return }
        searchCacheManager.saveSearchQuery(searchInput)
        getWeather(with: searchInput)
    }
    
    // MARK: - Network
    
    private func getWeather(with city: String) {
        error = nil
        currentWeatherModel = nil
        isLoading = true
        networkService.getWeather(from: city) { [weak self] error in
            self?.error = error
            self?.isLoading = false
        } successCompletion: { [weak self] forecastModel in
            self?.currentWeatherModel = forecastModel
            self?.isLoading = false
        }
    }
}
