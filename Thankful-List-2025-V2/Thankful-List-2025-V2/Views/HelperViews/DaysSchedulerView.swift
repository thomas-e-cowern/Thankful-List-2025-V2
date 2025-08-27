//
//  DaysSchedulerView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/27/25.
//

import SwiftUI
import TipKit
import UserNotifications

struct DaysSchedulerView: View {
    
    @Binding var selectedDays: Set<String>
    
    private let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                Text("Select Days")
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 8),
                        GridItem(.flexible(), spacing: 8),
                        GridItem(.flexible(), spacing: 8)
                    ],
                    spacing: 8
                ) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        DayChip(day: day, selectedDays: $selectedDays)
                    }
                }

                if selectedDays.isEmpty {
                    Text("Tip: choose at least one day to schedule a repeating reminder.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Day selection")
            .accessibilityValue(selectedDays.isEmpty
                                ? "No days selected"
                                : selectedDays.sorted(by: sortWeekday).joined(separator: ", "))
        }
    }
    
    private func sortWeekday(_ a: String, _ b: String) -> Bool {
        guard
            let ia = daysOfWeek.firstIndex(of: a),
            let ib = daysOfWeek.firstIndex(of: b)
        else { return a < b }
        return ia < ib
    }

}

#Preview {
    DaysSchedulerView(selectedDays: .constant(["Monday", "Wednesday"]))
}

// MARK: - Day Chip
private struct DayChip: View {
    let day: String
    @Binding var selectedDays: Set<String>

    private var isSelected: Bool { selectedDays.contains(day) }

    var body: some View {
        Toggle(day, isOn: binding)
            .toggleStyle(ChipToggleStyle())
            .accessibilityLabel(day)
            .accessibilityValue(isSelected ? "Selected" : "Not selected")
            .accessibilityHint(isSelected ? "Double-tap to deselect \(day)." : "Double-tap to select \(day).")
            .accessibilityIdentifier("Scheduler.Day.\(day)")
    }

    private var binding: Binding<Bool> {
        Binding(
            get: { isSelected },
            set: { on in
                if on { selectedDays.insert(day) } else { selectedDays.remove(day) }
            }
        )
    }
}

// MARK: - Chip Toggle Style
private struct ChipToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        // Button wrapper preserves tap target while we add explicit a11y below
        Button {
            configuration.isOn.toggle()
        } label: {
            configuration.label
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(configuration.isOn ? Color.accentColor.opacity(0.15) : Color(.secondarySystemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(configuration.isOn ? Color.accentColor : Color.gray.opacity(0.25), lineWidth: 1)
                )
                .foregroundStyle(configuration.isOn ? Color.accentColor : .primary)
        }
        .buttonStyle(.plain) // avoid extra row selection behavior inside Form
        .contentShape(Rectangle())
        // A11y fallbacks for pre-iOS 17:
               .accessibilityAddTraits(.isButton)
               .accessibilityAddTraits(configuration.isOn ? .isSelected : [])
               .accessibilityValue(configuration.isOn ? "Selected" : "Not selected")
    }
}
