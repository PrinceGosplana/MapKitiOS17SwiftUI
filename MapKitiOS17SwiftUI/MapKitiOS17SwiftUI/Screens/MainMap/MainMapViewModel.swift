//
//  MainMapViewModel.swift
//  MapKitiOS17SwiftUI
//
//  Created by Oleksandr Isaiev on 02.04.2024.
//

import MapKit
import SwiftUI
import Observation

@Observable
final class MainMapViewModel {
    var cameraPosition: MapCameraPosition = .region(.userRegion)
    var searchText = ""
    var searchResults = [MKMapItem]()
    var mapSelection: MKMapItem?
    var showDetails = false
    var getDirections = false
    var routeDisplaying = false
    var route: MKRoute?
    var routeDestinations: MKMapItem?

    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion

        let searchResults = try? await MKLocalSearch(request: request).start()
        self.searchResults = searchResults?.mapItems ?? []
    }

    func fetchRoute() {
        if let mapSelection  {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: .userLocation))
            request.destination = mapSelection

            Task {
                let result = try? await MKDirections(request: request).calculate()
                route = result?.routes.first
                routeDestinations = mapSelection

                withAnimation(.snappy) {
                    routeDisplaying = true
                    showDetails = false

                    if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                        cameraPosition = .rect(rect)
                    }
                }
            }
        }
    }
}
