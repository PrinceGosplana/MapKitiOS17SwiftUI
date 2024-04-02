//
//  LocationDetailView.swift
//  MapKitiOS17SwiftUI
//
//  Created by Oleksandr Isaiev on 02.04.2024.
//

import MapKit
import SwiftUI

struct LocationDetailView: View {

    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    @State private var lookAroundScene: MKLookAroundScene?
    @Binding var getDirections: Bool

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(mapSelection?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                }

                Spacer()

                Button {
                    show.toggle()
                    mapSelection = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray)
                }
            }

            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding()
            } else {
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
            }

            HStack(spacing: 24) {
                Button {
                    if let mapSelection {
                        mapSelection.openInMaps()
                    }
                } label: {
                    Text("Open in Maps")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(minWidth: 170, minHeight: 40)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button {
                    getDirections = true
                    show = false
                } label: {
                    Text("Get Directions")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(minWidth: 170, minHeight: 40)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { oldValue, newVale in
            fetchLookAroundPreview()
        }
        .padding()
    }
}

extension LocationDetailView {
    func fetchLookAroundPreview() {
        if let mapSelection {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try? await request.scene
            }
        }
    }
}

#Preview {
    LocationDetailView(mapSelection: .constant(nil),
                       show: .constant(false), getDirections: .constant(false))
}
