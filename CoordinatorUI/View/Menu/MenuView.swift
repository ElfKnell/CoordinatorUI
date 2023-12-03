//
//  MenuView.swift
//  CoordinatorUI
//
//  Created by Andrii Kyrychenko on 06/08/2023.
//

import SwiftUI

struct MenuView: View {

    var body: some View {
                
        TabView {

            StartMapView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            if #available(iOS 17, *) {
                MapSearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass.circle.fill")
                    }
            }
            
            PhotoViewCloud(location: "location")
                .tabItem { Label("Photo", systemImage: "cloud.fill") }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
            }
        }
            .onAppear() {
                UITabBar
                    .appearance()
                    .backgroundColor = .yellow.withAlphaComponent(0.3)
            }
            //.frame(height: 12)
            //.accentColor(.blue)
        .ignoresSafeArea()
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
