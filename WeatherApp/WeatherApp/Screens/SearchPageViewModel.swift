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
    private var networkService: NetworkService
    
    // MARK: - Init
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Business
    
    func onAppear() {
        // TODO: Show the data of the last location searched.
    }
    
    func searchButtonTapped(_ searchInput: String) {
        
    }
}
