//
//  WeatherModelView.swift
//  SimpleWeather
//
//  Created by Юрий Чекан on 17.05.2024.
//

import Foundation
import CoreLocation

@Observable final class WeatherViewModel {
    // MARK: -Propeerties
    var locationManager = LocationDataManager()
    var weatherManager = WeatherManager()
    
    var userWeather: ResponseBody?
    var defaultCitiesArray = [ResponseBody]()
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
    
    var userCityError: String?
    
    // MARK: -Load data for city by long lat
    func loadUserWeatherFor(location: CLLocationCoordinate2D) async throws {
            let result = try await weatherManager.loadWeatherFor(latitude: location.latitude, longitude: location.longitude)
            
            switch result {
            case .success(let success):
                self.userWeather = success
            case .failure(let failure):
                self.error = failure.localizedDescription
            }
    }
    // MARK: -Load data for array
    func loadDefaultArray() async throws {
        
        self.defaultCoordArray.enumerated().forEach { index, location in
            DispatchQueue.main.asyncAndWait {
                Task {
                    let result = try await weatherManager.loadWeatherFor(latitude: location.latitude, longitude: location.longitude)
                    
                    switch result {
                    case .success(let success):
                        self.defaultCitiesArray[index] = success
                    case .failure(let failure):
                        self.error = failure.localizedDescription
                    }
                }
            }
        }
    }
    // MARK: -Load data for city by name
    func loadWeatherForCityName(_ name: String) async throws {
        let result = try await weatherManager.loadWeatherForCityName(name)
        switch result {
        case .success(let success):
            var temp = true // same as .contains
            for item in defaultCitiesArray {
                if item.name == success.name {
                    temp = false
                    self.userCityError = "City already in list"
                    continue
                }
            }
            if temp == true {
                defaultCitiesArray.append(success)
            }
        case .failure(let failure):
            self.userCityError = failure.localizedDescription
        }
    }
    
    
    // MARK: -Lifecycle
    init() {
        defaultCitiesArray = Array(repeating: previewWeather, count: defaultCoordArray.count)
        locationManager.checkIfLocationIsEnabled()
        if locationManager.location != nil {
            Task {
                try await loadUserWeatherFor(location: locationManager.location!)
                try await loadDefaultArray()
            }
        }
    }
}
