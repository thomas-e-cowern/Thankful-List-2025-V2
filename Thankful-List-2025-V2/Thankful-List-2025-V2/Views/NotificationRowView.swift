//
//  NotificationRowView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/21/25.
//

import SwiftUI
import UserNotifications

struct NotificationRowView: View {
    let title: String
    let reason: String
    let hasDate: Bool
    let dateText: String?

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon is decorative (we’ll surface state in the row’s label/value)
            IconTile(hasDate: hasDate)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .lineLimit(2)
                    .accessibilityIdentifier("NotificationRow.Title")

                if !reason.isEmpty {
                    Text(reason)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .accessibilityIdentifier("NotificationRow.Reason")
                }

                if let dateText {
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .imageScale(.small)
                            .foregroundStyle(.secondary)
                            .accessibilityHidden(true) // decorative
                        Text("Scheduled for: \(dateText)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .accessibilityIdentifier("NotificationRow.DateText")
                    }
                }
            }

            Spacer()
        }
        .padding(12)
        .background(
            // Background is decorative
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.thinMaterial)
                .accessibilityHidden(true)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.gray.opacity(0.15))
                .accessibilityHidden(true)
        )

        // ————— Accessibility —————
        // Make the entire row read as one coherent element.
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabelText)
        .accessibilityValue(accessibilityValueText)
        // If the row is tappable in your list, you can add a hint like:
        // .accessibilityHint("Opens notification details.")
        .accessibilityIdentifier("NotificationRow")
        // Expose structured key/value on iOS 17+ (shows in VoiceOver rotor)
        .modifier(StructuredA11yContent(hasDate: hasDate, dateText: dateText))
    }

    private var accessibilityLabelText: Text {
        // Title is the primary label
        Text(title)
    }

    private var accessibilityValueText: Text {
        var parts: [String] = []

        if !reason.isEmpty {
            parts.append(reason)
        }

        if hasDate {
            if let dateText {
                parts.append("Scheduled for \(dateText)")
            } else {
                parts.append("Scheduled")
            }
        } else {
            parts.append("No schedule")
        }

        return Text(parts.joined(separator: ", "))
    }
}

/// Adds structured accessibility content on iOS 17+ without breaking older OSes.
private struct StructuredA11yContent: ViewModifier {
    let hasDate: Bool
    let dateText: String?

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .accessibilityCustomContent("Status", hasDate ? "Scheduled" : "No schedule")
                .accessibilityCustomContent("Scheduled for", dateText ?? "—", importance: .high)
        } else {
            content
        }
    }
}

struct IconTile: View {
    let hasDate: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))
                .accessibilityHidden(true) // decorative
            Image(systemName: hasDate ? "calendar" : "bell")
                .imageScale(.large)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true) // we announce status in the row’s value instead
        }
        .frame(width: 44, height: 44)
    }
}

#Preview {
    VStack(spacing: 16) {
        NotificationRowView(
            title: "Call Mom",
            reason: "Her birthday is this weekend",
            hasDate: true,
            dateText: "Friday at 7:00 PM"
        )
        NotificationRowView(
            title: "Gratitude check-in",
            reason: "",
            hasDate: false,
            dateText: nil
        )
    }
    .padding()
}
