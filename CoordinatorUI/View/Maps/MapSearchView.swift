//
//  MapSearchView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 16/08/2023.
//

import SwiftUI
import MapKit

@available(iOS 17.0, *)
struct MapSearchView: View {
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State private var searchText = ""
    @State private var results = [MKMapItem]()
    @State private var mapSelection: MKMapItem?
    @State private var showDetails = false
    @State private var getDirections = false
    @State private var routeDisplaying = false
    @State private var route: MKRoute?
    @State private var routeDistination: MKMapItem?
    
    var body: some View {
        Map(position: $cameraPosition, selection: $mapSelection) {
            Marker("My location", systemImage: "paperplane", coordinate: .userLocation)
                .tint(.red)
            
            ForEach(results, id: \.self) { item in
                if routeDisplaying {
                    if item == routeDistination {
                        let placeMark = item.placemark
                        Marker(placeMark.name ?? "", coordinate: placeMark.coordinate)
                    }
                } else {
                    let placeMark = item.placemark
                    Marker(placeMark.name ?? "", coordinate: placeMark.coordinate)
                }
            }
            
            if let route {
                MapPolyline(route.polyline)
                    .stroke(.green, lineWidth: 7)
            }
        }
        .overlay(alignment: .top) {
            VStack(alignment: .leading) {
                
                TextField("Search for a location...", text: $searchText)
                    .font(.subheadline)
                    .padding(12)
                    .background(.white)
                    .padding()
                    .shadow(radius: 10)
                
                if cameraPosition != .region(.userRegion) {
                    Button {
                        clean()
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward.2.circle")
                            .fontWeight(.bold)
                            .font(.system(size: 32))
                            .foregroundStyle(.red)
                    }
                    .padding(.horizontal)
                }
                
            }
        }
        .onSubmit(of: .text) {
            Task { await searchPlace() }
        }
        .onChange(of: getDirections, { oldValue, newValue in
            if newValue {
                fetchRoute()
            }
        })
        .onChange(of: mapSelection, { oldValue, newValue in
            showDetails = newValue != nil
        })
        .sheet(isPresented: $showDetails, content: {
            LocationsDetailView(mapSeliction: $mapSelection, show: $showDetails, getDirections: $getDirections)
                .presentationDetents([.height(340)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                .presentationCornerRadius(12)
        })
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
    }
}

@available(iOS 17.0, *)
extension MapSearchView {
    func searchPlace() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion
        
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
    }
    
    func fetchRoute() {
        if let mapSelection {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: .userLocation))
            request.destination = mapSelection
            
            Task {
                let result = try? await MKDirections(request: request).calculate()
                route = result?.routes.first
                routeDistination = mapSelection
                
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
    
    func clean() {
        cameraPosition = .region(.userRegion)
        searchText = ""
        results = []
        mapSelection = nil
        showDetails = false
        getDirections = false
        routeDistination = nil
        route = nil
        routeDisplaying = false
    }
}

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 25.7602, longitude: -80.2509)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}

struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 17.0, *) {
            MapSearchView()
        }
    }
}
