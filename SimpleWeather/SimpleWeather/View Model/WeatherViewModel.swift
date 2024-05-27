import Foundation
import CoreLocation
import Observation

@Observable final class WeatherViewModel {
    
    // MARK: - Properties
    var locationManager = LocationDataManager()
    var weatherManager = WeatherManager()
    
    var userWeather: ResponseBody?
    var defaultCitiesArray = [ResponseBody]()
    
    var defaultNamesArray: [String] {
        didSet {
            UserDefaults.standard.set(defaultNamesArray, forKey: "defaultNamesArray")
        }
    }
    
    var error: String? {
        didSet {
            print("DEBUG: an error occurred \(String(describing: error))")
        }
    }
    var userCityError: String?
    
    // MARK: - Load data for city by long lat
    func loadUserWeatherFor(location: CLLocationCoordinate2D) async throws {
        let result = try await weatherManager.loadWeatherFor(latitude: location.latitude, longitude: location.longitude)
        
        switch result {
        case .success(let success):
            self.userWeather = success
        case .failure(let failure):
            self.error = failure.localizedDescription
        }
    }
    
    // MARK: - Load data for array
    func loadDefaultArray() async {
        await withTaskGroup(of: Void.self) { group in
            for (index, name) in defaultNamesArray.enumerated() {
                group.addTask {
                    do {
                        let result = try await self.weatherManager.loadWeatherForCityName(name)
                        switch result {
                        case .success(let success):
                            self.defaultCitiesArray[index] = success
                        case .failure(let failure):
                            self.error = failure.localizedDescription
                        }
                    } catch {
                        self.error = error.localizedDescription
                    }
                }
            }
        }
    }
    
    // MARK: - Load data for city by name
    func loadWeatherForCityName(_ name: String) async {
        do {
            let result = try await weatherManager.loadWeatherForCityName(name)
            switch result {
            case .success(let success):
                if !defaultCitiesArray.contains(where: { $0.name == success.name }) {
                    defaultCitiesArray.append(success)
                    defaultNamesArray.append(name) // Add city name to the list and cache it
                } else {
                    self.userCityError = "City already in list"
                }
            case .failure(let failure):
                self.userCityError = failure.localizedDescription
            }
        } catch {
            self.userCityError = error.localizedDescription
        }
    }
    
    // MARK: - Add a new city
    func addCity(_ name: String) async {
        if defaultNamesArray.contains(name) {
            self.userCityError = "City already in list"
            return
        }
        
        do {
            let result = try await weatherManager.loadWeatherForCityName(name)
            switch result {
            case .success(let success):
                defaultCitiesArray.append(success)
                defaultNamesArray.append(name) // Add city name to the list and cache it
            case .failure(let failure):
                self.userCityError = failure.localizedDescription
            }
        } catch {
            self.userCityError = error.localizedDescription
        }
    }
    
    // MARK: - Lifecycle
    init() {
        if let cachedNames = UserDefaults.standard.array(forKey: "defaultNamesArray") as? [String] {
            self.defaultNamesArray = cachedNames
        } else {
            self.defaultNamesArray = [
                "Moscow",
                "Krasnodar",
                "Ufa",
                "Saint Petersburg",
                "Novosibirsk",
                "Chelyabinsk"
            ]
        }
        
        defaultCitiesArray = Array(repeating: previewWeather, count: defaultNamesArray.count)
        locationManager.checkIfLocationIsEnabled()
        if let location = locationManager.location {
            Task {
                do {
                    try await loadUserWeatherFor(location: location)
                } catch {
                    self.error = error.localizedDescription
                }
                await loadDefaultArray()
            }
        } else {
            Task {
                await loadDefaultArray()
            }
        }
    }
}
