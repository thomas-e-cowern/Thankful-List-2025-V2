//
//  Thankful_List_2025_V2App.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/18/25.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct Thankful_List_2025_V2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Thanks.self)
                .task {
                    // TODO: Remove try? Tips.resetDatastore() before shipping
                    // Below resets Tips when simulator is restarted
                    try? Tips.resetDatastore()
                    try? Tips.configure(
                        [
                            .displayFrequency(.immediate),
                            .datastoreLocation(.applicationDefault),
                        ]
                    )
                }
        }
    }
}
