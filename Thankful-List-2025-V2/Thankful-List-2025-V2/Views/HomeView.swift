//
//  HomeView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/18/25.
//

import SwiftUI
import TipKit

struct HomeView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var path = NavigationPath()
    
    let addThanksTip = AddThanksTip()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                VStack(spacing: 30) {
                    
                    Image("Thanks")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                    
                    Text("Welcome to the Grateful List!")
                        .font(.title)
                        .padding()
                    
                    Text("The Grateful List exists to help you keep track of people, places, experiences and things that you are grateful for in your life.")
                        .padding()
                    
                    Text("Not sure where to start?  Check out the info below...")
                        .padding(.horizontal)
                }
            }
            .navigationDestination(for: Thanks.self, destination: { thanks in
//                EditThanksView(navigationPath: $path, thanks: thanks)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "plus")
                        .onTapGesture {
                            let newThanks = Thanks(title: "", body: "", date: Date.now, isFavorite: false, icon: IconImages.star.rawValue, color: "#007AFF")
                            modelContext.insert(newThanks)
                            path.append(newThanks)
                        }
                        .popoverTip(addThanksTip)
                        .accessibilityHint("This will open up the form to add a new Thanks to your list.")
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .task {
            try? Tips.resetDatastore()
            try? Tips.configure(
                [
                    .displayFrequency(.immediate),
                    .datastoreLocation(.applicationDefault)
                ]
            )
        }
}
