//
//  NotificationsSectionView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/27/25.
//

import SwiftUI

struct NotificationsSectionView: View {
    @Binding var showNotificationSchedular: Bool
    @Binding var showScheduledNotifications: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "bell.badge")
                    .imageScale(.large)
                    .accessibilityHidden(true) // icon is decorative, text conveys meaning
                Text("Notifications")
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
            }

            VStack(spacing: 10) {
                Button {
                    showNotificationSchedular.toggle()
                } label: {
                    Label("Schedule Notifications", systemImage: "calendar.badge.plus")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityLabel("Schedule notifications")
                .accessibilityHint("Opens the scheduler to pick times and days.")

                Button {
                    showScheduledNotifications.toggle()
                } label: {
                    Label("See Scheduled Notifications", systemImage: "list.bullet.rectangle")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.bordered)
                .accessibilityLabel("See scheduled notifications")
                .accessibilityHint("Shows a list of notifications that are already scheduled.")
            }
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.gray.opacity(0.15)))
        // Treat the card as a region and read its children together
        .accessibilityElement(children: .contain)
        .accessibilitySortPriority(2)
        .accessibilityLabel("Notifications section")
        .accessibilityHint("Manage scheduling and review existing notifications.")
        .accessibilityAddTraits(.isSummaryElement)
    }
}

#Preview {
    NotificationsSectionView(showNotificationSchedular: .constant(false), showScheduledNotifications: .constant(false))
}
