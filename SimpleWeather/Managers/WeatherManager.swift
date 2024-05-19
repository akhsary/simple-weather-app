//
//  WeatherManager.swift
//  SimpleWeather
//
//  Created by Юрий on 10.05.2024.
//

import Foundation
//import Alamofire
import CoreLocation

// https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
// b522a2d63414c8b37c1c262907b47a4d
let key = "b522a2d63414c8b37c1c262907b47a4d"
final class WeatherManager {
// MARK: Async
    func loadWeatherFor(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> Result<ResponseBody, WeatherAPIError> {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(key)&units=metric") else {
            return Result.failure(.requestFailed(description: "Wrong URL"))
        }
        
        let urlRequest = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            
            guard let httResponse = response as? HTTPURLResponse else {
                return Result.failure(.requestFailed(description: "Request failed"))
            }
            
            guard httResponse.statusCode == 200 else {
                return Result.failure(.invalidStatusCode(statusCode: httResponse.statusCode))
            }
            
            do {
                let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
                return Result.success(decodedData)
            } catch {
                return Result.failure(.jsonParsingFailure)
            }
                
        } catch {
            return Result.failure(.unknownError(error: error))
        }
    }
    
// MARK: Alomofire
    /*
    func fetchDataWithAlomofire(latitude: CLLocationDegrees, longitude: CLLocationDegrees, complition: @escaping (Result<ResponseBody, WeatherAPIError>) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(key)&units=metric"
        AF.request(url)
            .validate()
            .response { response in
                guard let data = response.data else {
                    if let error = response.error {
                        complition(Result.failure(.requestFailed(description: "An error occured: \(error)")))
                    }
                    return
                }
                let decoder = JSONDecoder()
                guard let decodedData = try? decoder.decode(ResponseBody.self, from: data) else {
                    complition(Result.failure(.jsonParsingFailure))
                    return
                }
                complition(Result.success(decodedData))
            }
    }
     */
}
