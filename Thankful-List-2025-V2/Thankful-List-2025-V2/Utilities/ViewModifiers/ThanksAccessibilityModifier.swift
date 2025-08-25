//
//  ThanksAccessibilityModifier.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/25/25.
//
import SwiftUI

struct ThanksAccessibilityModifier: ViewModifier {
    let idString: String
    let isFavorite: Bool
    let labelText: String
    let hintText: String = "Opens details to view or edit."

    init(thank: Thanks) {
        self.idString = thank.id.uuidString
        self.isFavorite = thank.isFavorite

        // Precompute a short, friendly label for VO
        var parts: [String] = [thank.title.isEmpty ? "Untitled" : thank.title]
        if thank.isFavorite { parts.append("favorite") }
        parts.append("added \(DateCache.shared.dayTime.string(from: thank.date))")
        self.labelText = parts.joined(separator: ", ")
    }

    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text(labelText))
            .accessibilityHint(Text(hintText))
            .modifier(FavoriteTrait(isFavorite: isFavorite))
            .accessibilityIdentifier("thanksRow_\(idString)")
    }
}
