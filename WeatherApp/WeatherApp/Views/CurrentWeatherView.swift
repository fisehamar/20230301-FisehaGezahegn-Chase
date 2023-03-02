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
            Text(model.temperature + "°")
                .font(.title)
                .foregroundColor(.indigo)
            Text(model.weatherDescription)
                .font(.title3)
            HStack {
                Image(systemName: "drop")
                    .imageScale(.large)
                    .foregroundColor(.indigo)
                Text("Humidity: " + model.humidity + "%")
                    .font(.title3)
            }
            HStack {
                Image(systemName: "wind")
                    .imageScale(.large)
                    .foregroundColor(.indigo)
                Text("Speed: " + model.windSpeed + " mph")
                    .font(.title3)
            }
        }
        .padding(16)
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(model: CurrentWeatherModel.fixture)
    }
}
