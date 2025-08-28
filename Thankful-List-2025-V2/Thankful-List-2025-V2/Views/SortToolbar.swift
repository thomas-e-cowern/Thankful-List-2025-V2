//
//  SortToolbar.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/25/25.
//

import SwiftUI
import TipKit

/// Generic, reusable sort toolbar. Attach only on screens that need sorting.
public struct SortToolbar<Option: CaseIterable & Hashable>: ToolbarContent {
    @Binding var selection: Option
    var labelForOption: (Option) -> String
    var title: String = "Sort"
    var systemImage: String = "arrow.up.arrow.down"
    var sortTip = AddSortTip()

    public init(
        selection: Binding<Option>,
        labelForOption: @escaping (Option) -> String,
        title: String = "Sort",
        systemImage: String = "arrow.up.arrow.down",
    ) {
        self._selection = selection
        self.labelForOption = labelForOption
        self.title = title
        self.systemImage = systemImage
    }

    public var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Menu {
                // Inside the menu: expose a native Picker for semantic selection
                Picker(title, selection: $selection) {
                    ForEach(Array(Option.allCases), id: \.self) { option in
                        Text(labelForOption(option))
                            .tag(option)
                            .accessibilityLabel(labelForOption(option))
                    }
                }
                // Tell VO what the current selection is
                .accessibilityLabel(title)
                .accessibilityValue(labelForOption(selection))
                .accessibilityHint("Choose how items are ordered.")
                .accessibilityIdentifier("SortToolbar.Picker")
            } label: {
                Label(title, systemImage: systemImage)
                    // The label (rendered as a button) needs a concise name + live value
                    .accessibilityLabel(title)
                    .accessibilityValue(labelForOption(selection))
                    .accessibilityHint("Double-tap to choose a sort order. Swipe up or down to change quickly.")
                    .accessibilityIdentifier("SortToolbar.MenuButton")
                    // Let rotor users adjust without opening the menu
                    .accessibilityAdjustableAction { direction in
                        let all = Array(Option.allCases)
                        guard let idx = all.firstIndex(of: selection) else { return }
                        switch direction {
                        case .increment:
                            let next = all.index(after: idx)
                            selection = next < all.endIndex ? all[next] : all[all.startIndex]
                        case .decrement:
                            selection = idx > all.startIndex ? all[all.index(before: idx)] : all[all.index(before: all.endIndex)]
                        @unknown default:
                            break
                        }
                    }
                    // Offer a representation that feels like a picker to assistive tech
                    .accessibilityRepresentation {
                        Picker(title, selection: $selection) {
                            ForEach(Array(Option.allCases), id: \.self) { option in
                                Text(labelForOption(option)).tag(option)
                            }
                        }
                        .accessibilityIdentifier("SortToolbar.RepresentedPicker")
                    }
            }
            // Optional TipKit anchor stays on the label button
            .popoverTip(sortTip)
        }
    }
}

/// Convenience modifier to attach the reusable sort toolbar.
public extension View {
    func withSortToolbar<Option: CaseIterable & Hashable>(
        selection: Binding<Option>,
        labelForOption: @escaping (Option) -> String,
        title: String = "Sort",
        systemImage: String = "arrow.up.arrow.down",
    ) -> some View {
        self.toolbar {
            SortToolbar(
                selection: selection,
                labelForOption: labelForOption,
                title: title,
                systemImage: systemImage
            )
        }
    }
}
