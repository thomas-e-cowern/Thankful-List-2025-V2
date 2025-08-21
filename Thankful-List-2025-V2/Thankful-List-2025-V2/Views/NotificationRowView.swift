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
            IconTile(hasDate: hasDate)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .lineLimit(2)

                if !reason.isEmpty {
                    Text(reason)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }

                if let dateText {
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .imageScale(.small)
                            .foregroundStyle(.secondary)
                        Text("Scheduled for: \(dateText)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.thinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.gray.opacity(0.15))
        )
    }
}

struct IconTile: View {
    let hasDate: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))
            Image(systemName: hasDate ? "calendar" : "bell")
                .imageScale(.large)
                .foregroundStyle(.secondary)
        }
        .frame(width: 44, height: 44)
    }
}
