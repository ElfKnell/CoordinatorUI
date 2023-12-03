//
//  LocationsDetailView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 29/09/2023.
//

import SwiftUI
import MapKit

@available(iOS 17.0, *)
struct LocationsDetailView: View {
    
    @Binding var mapSeliction: MKMapItem?
    @Binding var show: Bool
    @State private var lookAroundScene: MKLookAroundScene?
    @Binding var getDirections: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(mapSeliction?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(mapSeliction?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.leading)
                }
                
                Spacer()
                
                Button {
                    show.toggle()
                    mapSeliction = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                }
            }
            
            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            } else {
                ContentUnavailableView("No preview availible", image: "eye.slash")
            }
            
            HStack(spacing: 24) {
                Button {
                    if let mapSeliction {
                        mapSeliction.openInMaps()
                    }
                } label: {
                    Text("Open in map")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 48)
                        .background(.green)
                        .cornerRadius(12)
                }
                
                Button {
                    getDirections = true
                    show = false
                } label: {
                    Text("Get directions")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 48)
                        .background(.blue)
                        .cornerRadius(12)
                }
            }
        }
        .onAppear {
            fetchLookAroundPreview()
        }
        .onChange(of: mapSeliction) { oldValue, newValue in
            fetchLookAroundPreview()
        }
    }
}

@available(iOS 17.0, *)
extension LocationsDetailView {
    func fetchLookAroundPreview() {
        if let mapSeliction {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSeliction)
                lookAroundScene = try? await request.scene
            }
        }
    }
}
