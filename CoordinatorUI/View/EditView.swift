//
//  EditView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 25/06/2022.
//

import SwiftUI

struct EditView: View {
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    
    var location: Location
    
    @StateObject private var editModel = EditModel()
    
    @StateObject var locationEdit = LocationEdit()
    
    @State private var name: String
    @State private var description: String
    
    var body: some View {

            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                
                NavigationLink(destination: PhotoView(newNameFile: "\(location.id).json")) {
                    Text("Choose Photo")
                }
                .navigationBarTitleDisplayMode(.inline)
                .padding()
                
                Section("Nearby...") {
                    switch editModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        List(editModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        var newLocation = location
                        newLocation.name = name
                        newLocation.description = description
                        
                        locationEdit.updateLocation(location, location: newLocation)
                        
                        dismiss()
                    }
                }
                
            }
            .task {
                await editModel.fetchNearbyPlaces(location: location)
            }
        }
    
    init(location: Location) {
        self.location = location

        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditView(location: Location.example)
        }
    }
}
