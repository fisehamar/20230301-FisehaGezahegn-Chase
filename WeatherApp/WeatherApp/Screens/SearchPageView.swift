//
//  SearchView.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/1/23.
//

import SwiftUI

struct SearchPageView: View {
    
    // MARK: - Properties
    
    
    
    // MARK: - State
    
    @State private var searchText: String = ""
    
    // MARK: - Views
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    instructionsView
                    searchView
                }
            }
            .padding(16)
            .navigationTitle("Weather Search")
        }
    }
    
    @ViewBuilder private var instructionsView: some View {
        HStack {
            Image(systemName: "sparkles")
                .imageScale(.large)
                .foregroundColor(.indigo)
            Text("Enter a city to get the weather.")
        }
    }
    
    @ViewBuilder private var searchView: some View {
        HStack {
            TextField("hello world!", text: $searchText)
            Button {
                print("Search Tapped.")
            } label: {
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
                    .foregroundColor(.indigo)
            }
        }
        .padding(.horizontal, 8)
        .textFieldStyle(.roundedBorder)
    }
}

// MARK: - Previews

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPageView()
    }
}
