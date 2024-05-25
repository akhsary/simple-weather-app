//
//  SimpleWeatherApp.swift
//  SimpleWeather
//
//  Created by Юрий on 10.05.2024.
//

import SwiftUI

@main
struct SimpleWeatherApp: App {
    @State private var weatherViewModel = WeatherViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(weatherManager: weatherViewModel)
        }
    }
}
