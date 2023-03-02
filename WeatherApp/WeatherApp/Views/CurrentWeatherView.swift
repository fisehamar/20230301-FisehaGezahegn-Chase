//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/2/23.
//

import SwiftUI

struct CurrentWeatherView: View {
    
    // MARK: - Properties
    
    @State private var model: CurrentWeatherModel
    
    // MARK: - Init
    
    init(model: CurrentWeatherModel) {
        self.model = model
    }
    
    // MARK: - Views
    
    var body: some View {
        VStack(spacing: 16) {
            Text(model.name + ", " + model.country)
                .font(.title)
            imageView
            Text(model.temperature + "°")
                .font(.title)
                .foregroundColor(.indigo)
            Text(model.weatherDescription)
                .font(.title3)
            detailsView
        }
        .padding(16)
    }
    
    /// The view with the image. First checks if the image has previously been downloaded.
    // Given more time, I would wrap this in its own video with its own loading indicator.
    @ViewBuilder private var imageView: some View {
        AsyncImage(url: model.weatherIconUrl)
    }
    
    @ViewBuilder private var detailsView: some View {
        detailView(icon: "drop", text: "Humidity: " + model.humidity + "%")
        detailView(icon: "wind", text: "Speed: " + model.windSpeed + " mph")
    }
    
    @ViewBuilder private func detailView(icon: String, text: String) -> some View {
        HStack {
            Image(systemName: icon)
                .imageScale(.large)
                .foregroundColor(.indigo)
            Text(text)
                .font(.title3)
        }
    }
}

// MARK: - Previews

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(model: CurrentWeatherModel.fixture)
    }
}
