//
//  FavoriteTrait.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/25/25.
//

import SwiftUI

struct FavoriteTrait: ViewModifier {
    let isFavorite: Bool
    func body(content: Content) -> some View {
        if isFavorite {
            content.accessibilityAddTraits(.isSelected)
        } else {
            content
        }
    }
}
