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
// If there was more time, we would unit test this class as it has dependency injection capabilities.
// But my concern was first to make its dependencies unit tested to make it easier to test this model.
class SearchPageViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private var networkService: NetworkService
    private var searchCacheManager: SearchCacheManager
    var locationPermission: LocationPermission?
    
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
        // If the permission has been given, don't download the last search.
        if locationPermission?.isPermissionGranted() == false,
           let previousCity = searchCacheManager.loadSearchQuery() {
            getWeather(with: previousCity)
        }
    }
    
    func searchButtonTapped(_ searchInput: String) {
        guard !isLoading else { return }
        searchCacheManager.saveSearchQuery(searchInput)
        getWeather(with: searchInput)
    }
    
    // MARK: - Network
    
    func getWeather(lat: Double, lon: Double) {
        networkRequestStarted()
        networkService.getWeather(from: .init(lat: lat, lon: lon)) { [weak self] error in
            self?.networkRequestStopped(with: error)
        } successCompletion: { [weak self] forecastModel in
            self?.networkRequestSuccessful(data: forecastModel)
        }
    }
    
    private func getWeather(with city: String) {
        networkRequestStarted()
        networkService.getWeather(from: city) { [weak self] error in
            self?.networkRequestStopped(with: error)
        } successCompletion: { [weak self] forecastModel in
            self?.networkRequestSuccessful(data: forecastModel)
        }
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
    
    private func networkRequestSuccessful(data: CurrentWeatherModel) {
        currentWeatherModel = data
        isLoading = false
    }
}
