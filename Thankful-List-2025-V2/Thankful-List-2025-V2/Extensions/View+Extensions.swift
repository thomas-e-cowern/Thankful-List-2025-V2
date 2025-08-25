//
//  View+Extensions.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/25/25.
//

import SwiftUI

private extension View {
    func thanksAccessibility(_ thank: Thanks) -> some View {
        modifier(ThanksAccessibilityModifier(thank: thank))
    }
}
