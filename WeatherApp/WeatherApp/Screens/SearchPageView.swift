//
//  SearchView.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/1/23.
//

import SwiftUI

struct SearchPageView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: SearchPageViewModel
    
    // MARK: - View State
    
    @State private var searchText: String = ""
    
    // MARK: - Init
    
    init(viewModel: SearchPageViewModel = SearchPageViewModel()) {
        self.viewModel = viewModel
    }
    
    // MARK: - Views
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    headerView
                    searchView
                    weatherView
                }
            }
            .padding(16)
            .navigationTitle("Weather Search")
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    /// The view containing the instructions, search, and errors (if any).
    @ViewBuilder private var headerView: some View {
        HStack {
            Image(systemName: "sparkles")
                .imageScale(.large)
                .foregroundColor(.indigo)
            Text("Enter a city and tap the search button to get the weather.")
        }
        if let error = viewModel.error {
            Text(error)
                .foregroundColor(.red)
        }
    }
    
    /// The view with the text filed and search button.
    /// if given more time, this would be better encapsulated with a delegate for the action for reusability.
    @ViewBuilder private var searchView: some View {
        HStack {
            TextField("Enter a City", text: $searchText)
            Button {
                viewModel.searchButtonTapped(searchText)
            } label: {
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
                    .foregroundColor(.indigo)
            }
        }
        .padding(.horizontal, 8)
        .textFieldStyle(.roundedBorder)
    }
    
    /// The view with the weather's information if the data is available.
    @ViewBuilder private var weatherView: some View {
        if let model = viewModel.currentWeatherModel {
            CurrentWeatherView(model: model)
        } else {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}

// MARK: - Previews

struct SearchView_Previews: PreviewProvider {
    
    static var viewModel: SearchPageViewModel {
        let model = SearchPageViewModel()
        model.currentWeatherModel = CurrentWeatherModel.fixture
        return model
    }
    
    static var previews: some View {
        SearchPageView(viewModel: viewModel)
    }
}
