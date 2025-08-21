//
//  NotificationListView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/21/25.
//

import SwiftUI
import UserNotifications

// A simple model to represent a scheduled notification
struct NotificationItem: Identifiable {
    let id: String
    let request: UNNotificationRequest
    let dateComponents: DateComponents?
}

struct NotificationListView: View {
    @State private var notifications: [NotificationItem] = []

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()

                ListContent(
                    notifications: notifications,
                    deleteAction: deleteNotification,
                    dateText: { formattedDate(from: $0) }
                )
            }
            .navigationTitle("Scheduled Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: loadPendingNotifications) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                            .accessibilityLabel("Refresh")
                    }
                }
            }
            .onAppear(perform: loadPendingNotifications)
        }
    }

    // MARK: - Data

    func loadPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let items: [NotificationItem] = requests.map { request in
                let comps = (request.trigger as? UNCalendarNotificationTrigger)?.dateComponents
                return NotificationItem(id: request.identifier, request: request, dateComponents: comps)
            }
            DispatchQueue.main.async {
                self.notifications = items
            }
        }
    }

    func formattedDate(from components: DateComponents?) -> String {
        guard
            let components = components,
            let date = Calendar.current.date(from: components)
        else {
            return "Unknown date"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE 'at' h:mm a" // e.g., Monday at 9:30 AM
        return formatter.string(from: date)
    }

    func deleteNotification(at offsets: IndexSet) {
        for index in offsets {
            let notification = notifications[index]
            removeNotification(withIdentifier: notification.id)
        }
        notifications.remove(atOffsets: offsets)
    }

    func removeNotification(withIdentifier id: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id])
        center.removeDeliveredNotifications(withIdentifiers: [id])
    }
}

// MARK: - Extracted Views (keeps type-checker happy)

private struct BackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
            startPoint: .top, endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

private struct ListContent: View {
    let notifications: [NotificationItem]
    let deleteAction: (IndexSet) -> Void
    let dateText: (DateComponents?) -> String

    var body: some View {
        if notifications.isEmpty {
            EmptyStateView()
        } else {
            NotificationsList(
                rows: rows,
                deleteAction: deleteAction
            )
        }
    }

    // Precompute light-weight row models to avoid heavy inference in the view tree
    private var rows: [NotificationRowModel] {
        notifications.map { item in
            NotificationRowModel(
                id: item.id,
                title: item.request.content.title,
                reason: item.request.content.body,
                hasDate: (item.dateComponents != nil),
                dateString: item.dateComponents.map { dateText($0) }
            )
        }
    }
}

private struct NotificationsList: View {
    let rows: [NotificationRowModel]
    let deleteAction: (IndexSet) -> Void

    var body: some View {
        List {
            Section(header: SectionHeader()) {
                ForEach(rows) { row in
                    NotificationRowView(
                        title: row.title,
                        reason: row.reason,
                        hasDate: row.hasDate,
                        dateText: row.dateString
                    )
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowSeparator(.hidden)
                }
                .onDelete(perform: deleteAction)
            }
        }
        .listStyle(.insetGrouped)
    }
}

// A super-light model for the row so the List/ForEach doesn’t have to compute anything
private struct NotificationRowModel: Identifiable {
    let id: String
    let title: String
    let reason: String
    let hasDate: Bool
    let dateString: String?
}

private struct SectionHeader: View {
    var body: some View {
        Text("Upcoming")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}

private struct EmptyStateView: View {
    var body: some View {
        ContentUnavailableView(
            "You have no scheduled notifications yet.",
            systemImage: "clock.badge.checkmark",
            description: Text("When you add notifications to your list, they will appear here.")
        )
        .padding()
    }
}

// MARK: - Preview
#Preview {
    NotificationListView()
}
