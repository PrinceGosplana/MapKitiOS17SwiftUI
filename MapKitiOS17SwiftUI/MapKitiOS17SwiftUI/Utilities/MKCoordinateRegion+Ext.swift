//
//  MKCoordinateRegion+Ext.swift
//  MapKitiOS17SwiftUI
//
//  Created by Oleksandr Isaiev on 02.04.2024.
//

import MapKit


extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        .init(center: .userLocation,
              latitudinalMeters: 10_000,
              longitudinalMeters: 10_000)
    }
}
