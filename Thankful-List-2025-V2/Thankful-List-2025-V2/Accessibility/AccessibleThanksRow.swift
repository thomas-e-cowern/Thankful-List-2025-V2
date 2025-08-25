//
//  AccessibleThanksRow.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/25/25.
//

import SwiftUI

struct AccessibleThanksRow: View {
    let thank: Thanks
    
    // Precompute simple values in init to keep the body trivial
    private let idString: String
    private let isFavorite: Bool
    private let labelText: String
    
    init(thank: Thanks) {
        self.thank = thank
        self.idString = thank.id.uuidString
        self.isFavorite = thank.isFavorite
        
        var parts: [String] = [thank.title.isEmpty ? "Untitled" : thank.title]
        if thank.isFavorite { parts.append("favorite") }
        parts.append("added \(DateCache.shared.dayTime.string(from: thank.date))")
        self.labelText = parts.joined(separator: ", ")
    }
    
    var body: some View {
        
        ThanksRowView(thanks: thank)
        // Keep each modifier very plain; avoid complex conditionals/ternaries here
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text(verbatim: labelText))
            .accessibilityHint(Text("Opens details to view or edit."))
            .accessibilityIdentifier("thanksRow_\(idString)")
            .modifier(FavoriteTrait(isFavorite: isFavorite))
        
    }
}
