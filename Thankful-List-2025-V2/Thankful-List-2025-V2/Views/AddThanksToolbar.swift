//
//  AddThanksToolbar.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/21/25.
//

import SwiftUI
import SwiftData
import TipKit

struct AddThanksToolbar: ToolbarContent {
    @Binding var path: NavigationPath
    var icon: IconImages = .star
    var colorHex: String = "#007AFF"
    
//    private let addThanksTip = AddThanksTip()

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            AddThanksButton(path: $path, icon: icon, colorHex: colorHex)
//                .popoverTip(addThanksTip)
        }
    }
}

extension View {
    func addThanksToolbar(
        path: Binding<NavigationPath>,
        icon: IconImages = .star,
        colorHex: String = "#007AFF"
    ) -> some View {
        self.toolbar {
            AddThanksToolbar(path: path, icon: icon, colorHex: colorHex)
        }
    }
}

private struct AddThanksButton: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var path: NavigationPath

    var icon: IconImages = .star
    var colorHex: String = "#007AFF"

    @State private var isNavigating = false   // debounce

    var body: some View {
        Button(action: addThanks) {
            Image(systemName: "plus")
                .imageScale(.large)
        }
        
        .accessibilityLabel("Add new Thanks")
        .accessibilityHint("Opens the form to add a new gratitude entry.")
    }

    @MainActor
    private func addThanks() {
        guard !isNavigating else { return }
        isNavigating = true

        let newThanks = Thanks(
            title: "",
            reason: "",
            date: .now,
            isFavorite: false,
            icon: icon.rawValue,
            color: colorHex
        )
        modelContext.insert(newThanks)

        // Defer navigation to next runloop tick → avoids multiple updates this frame
        DispatchQueue.main.async {
            withAnimation(.snappy) {
                path.append(newThanks)
            }
            isNavigating = false
        }
    }
}
