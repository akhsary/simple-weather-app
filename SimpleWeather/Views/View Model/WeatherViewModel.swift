//
//  WeatherModelView.swift
//  SimpleWeather
//
//  Created by Юрий Чекан on 17.05.2024.
//

import Foundation
import CoreLocation

@Observable final class WeatherViewModel {
    var locationManager = LocationDataManager()
    var weatherManager = WeatherManager()
    
    var userWeather: ResponseBody?
    var deafultCitiesArray: [ResponseBody] = []
    var defaultCoordArray: [CLLocationCoordinate2D] {
        [
            CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6172),
            CLLocationCoordinate2D(latitude: 59.9375, longitude: 30.3086),
            CLLocationCoordinate2D(latitude: 55.0500, longitude: 82.9500),
            CLLocationCoordinate2D(latitude: 56.8356, longitude: 60.6128),
            CLLocationCoordinate2D(latitude: 55.7964, longitude: 49.1089),
            CLLocationCoordinate2D(latitude: 56.3269, longitude: 44.0075),
            CLLocationCoordinate2D(latitude: 45.0368, longitude: 35.3779),
            CLLocationCoordinate2D(latitude: 45.71168, longitude: 34.39274),
            CLLocationCoordinate2D(latitude: 44.9572, longitude: 34.1108)
        ]
    }
    
    var error: String?
//        didSet {
//            print("DEBUG: an error occured \(String(describing: error))")
//        }
    

    func loadUserWeatherFor(location: CLLocationCoordinate2D) async throws {
            let result = try await weatherManager.loadWeatherFor(latitude: location.latitude, longitude: location.longitude)
            
            switch result {
            case .success(let success):
                self.userWeather = success
            case .failure(let failure):
                self.error = failure.localizedDescription
            }
    }
    
    func loadDefaultArray() async throws {
        
        self.defaultCoordArray.forEach { location in
            Task { 
                let result = try await weatherManager.loadWeatherFor(latitude: location.latitude, longitude: location.longitude)
                
                switch result {
                case .success(let success):
                    self.deafultCitiesArray.append(success)
                case .failure(let failure):
                    self.error = failure.localizedDescription
                }
            }
        }
    }
     
    init(locationManager: LocationDataManager = LocationDataManager(), weatherManager: WeatherManager = WeatherManager(), userWeather: ResponseBody? = nil, deafultCitiesArray: [ResponseBody] = [], error: String? = nil) {
        self.locationManager = locationManager
        self.weatherManager = weatherManager
        self.userWeather = userWeather
        self.deafultCitiesArray = deafultCitiesArray
        self.error = error
        self.deafultCitiesArray = deafultCitiesArray
        locationManager.checkIfLocationIsEnabled()
        if locationManager.location != nil {
            Task {
                try await loadUserWeatherFor(location: locationManager.location!)
                try await loadDefaultArray()
            }
        }
    }
}
