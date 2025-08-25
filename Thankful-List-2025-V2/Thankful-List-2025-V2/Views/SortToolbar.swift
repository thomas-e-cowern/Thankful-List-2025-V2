//
//  SortToolbar.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/25/25.
//

import SwiftUI

import SwiftUI
import TipKit

/// Generic, reusable sort toolbar. Attach only on screens that need sorting.
public struct SortToolbar<Option: CaseIterable & Hashable>: ToolbarContent {
    @Binding var selection: Option
    var labelForOption: (Option) -> String
    var title: String = "Sort"
    var systemImage: String = "arrow.up.arrow.down"
    var tip: (any Tip)? = nil   // optional TipKit tip (pass nil if not needed)

    public init(
        selection: Binding<Option>,
        labelForOption: @escaping (Option) -> String,
        title: String = "Sort",
        systemImage: String = "arrow.up.arrow.down",
        tip: (any Tip)? = nil
    ) {
        self._selection = selection
        self.labelForOption = labelForOption
        self.title = title
        self.systemImage = systemImage
        self.tip = tip
    }

    public var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Menu {
                Picker(title, selection: $selection) {
                    ForEach(Array(Option.allCases), id: \.self) { option in
                        Text(labelForOption(option)).tag(option)
                    }
                }
                // Let VoiceOver announce current choice
                .accessibilityValue(labelForOption(selection))
            } label: {
                Label(title, systemImage: systemImage)
                    .accessibilityLabel("\(title) list")
                    .accessibilityHint("Choose how items are ordered.")
                    .accessibilityValue(labelForOption(selection))
            }
            // Optional TipKit popover (safe anchor on label view)
            .popoverTip(tip)
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
        tip: (any Tip)? = nil
    ) -> some View {
        self.toolbar {
            SortToolbar(
                selection: selection,
                labelForOption: labelForOption,
                title: title,
                systemImage: systemImage,
                tip: tip
            )
        }
    }
}
