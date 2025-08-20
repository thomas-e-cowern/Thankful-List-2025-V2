//
//  Previewer.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/20/25.
//

import Foundation
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    let thanks: Thanks
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Thanks.self, configurations: config)
        
        thanks = Thanks(title: "My friends and family", reason: "They are the ones who make life worth living", date: Date.now, isFavorite: true, icon: "star", color: "#007AFF")
        
        container.mainContext.insert(thanks)
    }
}
