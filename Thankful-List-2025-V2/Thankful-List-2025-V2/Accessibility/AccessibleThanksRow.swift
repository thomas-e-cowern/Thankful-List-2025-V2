//
//  AccessibleThanksRow.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/25/25.
//

import SwiftUI

struct AccessibleThanksRow<RowContent: View>: View {
    let thank: Thanks
    @ViewBuilder var content: RowContent

    // Precompute strings so the view tree is simple
    private var labelText: String {
        var parts: [String] = [thank.title.isEmpty ? "Untitled" : thank.title]
        if thank.isFavorite { parts.append("favorite") }
        parts.append("added \(DateCache.shared.dayTime.string(from: thank.date))")
        return parts.joined(separator: ", ")
    }

    private var hintText: String { "Opens details to view or edit." }

    var body: some View {
        NavigationLink(value: thank) {
            // Wrap content so VO treats it as a single element
            content
                .accessibilityElement(children: .combine)
                .accessibilityLabel(Text(labelText))
                .accessibilityHint(Text(hintText))
                // Apply trait conditionally without ternaries in the chain
                .modifier(FavoriteTrait(isFavorite: thank.isFavorite))
                .accessibilityIdentifier("thanksRow_\(thank.id.uuidString)")
        }
    }
}
