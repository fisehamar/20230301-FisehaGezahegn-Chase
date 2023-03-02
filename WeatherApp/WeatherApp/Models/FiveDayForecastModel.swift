//
//  FiveDayForecastModel.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/1/23.
//

import Foundation

/// The top-level model that represents the response from the 5-Day Forecast Weather API.
struct FiveDayForecastModel: Codable {
    
    var city: FiveDayForecastCityModel
    /// A list of days and their associated weather data.
    var days: [FiveDayForecastDayModel]
    
    enum CodingKeys: String, CodingKey {
        case city
        case days = "list"
    }
}

/// Represents the data for the city.
struct FiveDayForecastCityModel: Codable {
    var name: String
    var country: String
}

/// Represents the weather data for a day.
struct FiveDayForecastDayModel: Codable {
    
    private var main: FiveDayForecastDayMainModel
    private var weathers: [FiveDayForecastDayWeatherModel]
    
    var temperature: Double {
        convertKelvinToFahrenheit(main.temp)
    }
    var weather: FiveDayForecastDayWeatherModel {
        return weathers.first ?? FiveDayForecastDayWeatherModel(main: "", description: "", icon: "")
    }
    
    enum CodingKeys: String, CodingKey {
        case main
        case weathers = "weather"
    }
    
    private func convertKelvinToFahrenheit(_ kelvin: Double?) -> Double {
        guard let kelvin = kelvin else { return 0.0 }
        return (kelvin - 273.15) * 9.0 / 5.0 + 32
    }
}

struct FiveDayForecastDayMainModel: Codable {
    var temp: Double
}

struct FiveDayForecastDayWeatherModel: Codable {
    var main: String
    var description: String
    var icon: String
}
