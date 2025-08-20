//
//  ContentView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/18/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sortOrder = SortDescriptor(\Thanks.title)
    
    var body: some View {
        VStack {
            TabView {
                Tab("Home", systemImage: "house") {
                    HomeView()
                }
                Tab("Thanks List", systemImage: "list.bullet") {
                    Text("Thanks List View")
                    ListThanksView(sort: sortOrder)
                }
                Tab("Favorites", systemImage: "heart") {
//                    FavoritesView(sort: sortOrder)
                    Text("Favorites View")
                }
                Tab("Settings", systemImage: "gear") {
//                    SettingsView()
                    Text("Settings View")
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
