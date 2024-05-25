//
//  LocationManager.swift
//  SimpleWeather
//
//  Created by Юрий on 10.05.2024.
//

import Foundation
import CoreLocation
final  class LocationDataManager: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var location: CLLocationCoordinate2D?
    var isLoading = false
    
    
    func checkIfLocationIsEnabled() {
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager = CLLocationManager()
            self.locationManager!.delegate = self
            self.checkLocationAytarization()
        }  else {
            print("some View will appear later")
        }
    }
    
    private func checkLocationAytarization() {
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("some View will appear later")
        case .denied:
            print("some View will appear later")
        case .authorizedAlways, .authorizedWhenInUse:
            loadLocation(locationManager)
        @unknown default:
            break
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAytarization()
    }
    func loadLocation(_ locationManager: CLLocationManager) {
        isLoading = true
        location = locationManager.location?.coordinate
        isLoading = false
    }    
}
