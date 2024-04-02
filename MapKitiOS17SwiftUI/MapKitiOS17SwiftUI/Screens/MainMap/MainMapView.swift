//
//  ContentView.swift
//  MapKitiOS17SwiftUI
//
//  Created by Oleksandr Isaiev on 02.04.2024.
//

import MapKit
import SwiftUI

struct MainMapView: View {

    @State var viewModel = MainMapViewModel()

    var body: some View {
        Map(position: $viewModel.cameraPosition, selection: $viewModel.mapSelection) {
            /*
             /// Default marker
            Marker("My location", systemImage: "paperplane", coordinate: .userLocation)
                .tint(.indigo)
             */

            Annotation("My location", coordinate: .userLocation) {
                AnnotationView()
            }

            ForEach(viewModel.searchResults, id: \.self) { item in
                // if we not display a route - show everything
                if viewModel.routeDisplaying {
                    if item == viewModel.routeDestinations {
                        let placemark = item.placemark
                        Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                    }
                } else {
                    let placemark = item.placemark
                    Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                }
            }

            if let route = viewModel.route {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 6)
            }
        }
        .overlay(alignment: .top) {
            TextField("Search for a location...", text: $viewModel.searchText)
                .font(.subheadline)
                .padding(12)
                .background(.white)
                .padding()
                .shadow(radius: 10)
        }
        .onSubmit(of: .text) {
            Task { await viewModel.searchPlaces()  }
        }
        .onChange(of: viewModel.getDirections) { oldValue, newValue in
            if newValue { viewModel.fetchRoute() }
        }
        .onChange(of: viewModel.mapSelection) { oldValue, newValue in
            viewModel.showDetails = newValue != nil
        }
        .sheet(isPresented: $viewModel.showDetails) {
            LocationDetailView(mapSelection: $viewModel.mapSelection, show: $viewModel.showDetails, getDirections: $viewModel.getDirections)
                .presentationDetents([.height(340)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                .presentationCornerRadius(12)
        }
        .mapControls {
            MapCompass()
            MapUserLocationButton()
        }
    }
}

#Preview {
    MainMapView()
}
