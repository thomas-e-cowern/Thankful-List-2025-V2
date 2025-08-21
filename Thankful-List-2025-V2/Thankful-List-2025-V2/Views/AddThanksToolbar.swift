//
//  AddThanksToolbar.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/21/25.
//

import SwiftUI
import SwiftData

struct AddThanksToolbar: ToolbarContent {
    @Environment(\.modelContext) private var modelContext
    @Binding var path: NavigationPath

    var icon: IconImages = .star
    var colorHex: String = "#007AFF"
    var onAdd: ((Thanks) -> Void)? = nil   // optional callback

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                let newThanks = Thanks(
                    title: "",
                    reason: "",
                    date: .now,
                    isFavorite: false,
                    icon: icon.rawValue,
                    color: colorHex
                )
                modelContext.insert(newThanks)
                path.append(newThanks)
                onAdd?(newThanks)
            } label: {
                Image(systemName: "plus")
                    .imageScale(.large)
            }
            .accessibilityLabel("Add new Thanks")
            .accessibilityHint("Opens the form to add a new gratitude entry.")
        }
    }
}

extension View {
    func addThanksToolbar(
        path: Binding<NavigationPath>,
        icon: IconImages = .star,
        colorHex: String = "#007AFF",
        onAdd: ((Thanks) -> Void)? = nil
    ) -> some View {
        self.toolbar {
            AddThanksToolbar(path: path, icon: icon, colorHex: colorHex, onAdd: onAdd)
        }
    }
}
