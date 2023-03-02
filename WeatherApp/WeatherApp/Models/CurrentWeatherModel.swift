//
//  CurrentWeatherModel.swift
//  WeatherApp
//
//  Created by Fiseha Gezahegn on 3/2/23.
//

import Foundation

/// The top-level object of the current weather response with convenience accessors.
struct CurrentWeatherModel: Codable {
    
    var name: String
    var country: String {
        sys.country
    }
    
    var weatherType: String {
        weather.first?.type ?? ""
    }
    
    var weatherDescription: String {
        weather.first?.description ?? ""
    }
    
    var weatherIconUrl: URL? {
        URL(string: "http://openweathermap.org/img/wn/" + (weather.first?.icon ?? "") + "@2x.png")
    }
    
    var temperature: String {
        let fahrenheit = (main.temp - 273.15) * 9.0 / 5.0 + 32
        return "\(fahrenheit)".components(separatedBy: ".").first ?? ""
    }
    
    var humidity: String {
        "\(main.humidity)"
    }
    
    var windSpeed: String {
        "\(wind.speed)"
    }
    
    private var weather: [WeatherModel]
    private var main: CurrentMainModel
    private var wind: CurrentWindModel
    private var sys: CurrentSysModel
    
    init(name: String, weather: [WeatherModel], main: CurrentMainModel, wind: CurrentWindModel, sys: CurrentSysModel) {
        self.name = name
        self.weather = weather
        self.main = main
        self.wind = wind
        self.sys = sys
    }
}

struct WeatherModel: Codable {
    var type: String
    var description: String
    var icon: String
    
    enum CodingKeys: String, CodingKey {
        case type = "main"
        case description
        case icon
    }
}

struct CurrentMainModel: Codable {
    var temp: Double
    var humidity: Double
}

struct CurrentWindModel: Codable {
    var speed: Double
}

struct CurrentSysModel: Codable {
    var country: String
}

// Convenience for testing purposes.
extension CurrentWeatherModel {
    static var fixture: CurrentWeatherModel {
        return CurrentWeatherModel(
            name: "Dallas",
            weather: [.init(type: "Rain", description: "light rain", icon: "10d")],
            main: .init(temp: 200, humidity: 30),
            wind: .init(speed: 0.55),
            sys: .init(country: "US")
        )
    }
}
