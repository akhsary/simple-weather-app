//
//  WeatherModel.swift
//  SimpleWeather
//
//  Created by Юрий on 10.05.2024.
//

struct ResponseBody: Decodable, Identifiable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponseBody {
    var id: String {
        self.name
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double {feels_like }
    var tempMin: Double { temp_min }
    var tempMax: Double { temp_max }
}

extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}
