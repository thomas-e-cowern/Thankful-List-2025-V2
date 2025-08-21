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
                    ListThanksView(sort: sortOrder)
                }
                Tab("Favorites", systemImage: "heart") {
                    FavoritesView(sort: sortOrder)
                }
                Tab("Settings", systemImage: "gear") {
                    SettingsView()
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
