//
//  MapView.swift
//  SimpleWeather
//
//  Created by Юрий on 10.05.2024.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    var locationInvalid: ResponseBody.CoordinatesResponse
    var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: locationInvalid.lat, longitude: locationInvalid.lon)
    }
    var body: some View {
        Map(position: .constant(.region(region)))
    }

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}


