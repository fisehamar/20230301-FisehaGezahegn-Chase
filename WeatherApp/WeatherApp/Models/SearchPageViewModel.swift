//
//  SearchPageViewModel.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/1/23.
//

import CoreLocation
import Combine
import Foundation

/// The view model for a `SearchPageView` screen.
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
        if let previousCity = searchCacheManager.loadSearchQuery() {
            getWeather(with: previousCity)
        }
    }
    
    func searchButtonTapped(_ searchInput: String) {
        guard !isLoading else { return }
        searchCacheManager.saveSearchQuery(searchInput)
        getWeather(with: searchInput)
    }
    
    private func networkRequestStarted() {
        error = nil
        currentWeatherModel = nil
        isLoading = true
    }
    
    private func networkRequestStopped(with error: String?) {
        self.error = error
        isLoading = false
    }
    
    // MARK: - Network
    
    func getWeather(lat: Double, lon: Double) {
        networkRequestStarted()
        networkService.getWeather(from: .init(lat: lat, lon: lon)) { [weak self] error in
            self?.networkRequestStopped(with: error)
        } successCompletion: { [weak self] forecastModel in
            self?.currentWeatherModel = forecastModel
            self?.isLoading = false
        }
    }
    
    private func getWeather(with city: String) {
        networkRequestStarted()
        networkService.getWeather(from: city) { [weak self] error in
            self?.networkRequestStopped(with: error)
        } successCompletion: { [weak self] forecastModel in
            self?.currentWeatherModel = forecastModel
            self?.isLoading = false
        }
    }
}
