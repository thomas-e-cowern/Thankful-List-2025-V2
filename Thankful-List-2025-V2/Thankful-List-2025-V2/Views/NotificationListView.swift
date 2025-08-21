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
                // Soft background
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                List {
                    Section {
                        ForEach(notifications) { item in
                            NotificationRowView(item: item, dateText: formattedDate(from: item.dateComponents))
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .listRowSeparator(.hidden)
                                .background(Color.clear)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        deleteNotification(at: IndexSet(integer: notifications.firstIndex(where: { $0.id == item.id })!))
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                        .onDelete(perform: deleteNotification)
                    } header: {
                        if !notifications.isEmpty {
                            Text("Upcoming")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .animation(.default, value: notifications)
                .overlay {
                    if notifications.isEmpty {
                        ContentUnavailableView(
                            "You have no scheduled notifications yet.",
                            systemImage: "clock.badge.checkmark",
                            description: Text("When you add notifications to your list, they will appear here.")
                        )
                        .padding()
                    }
                }
            }
            .navigationTitle("Scheduled Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        loadPendingNotifications()
                    } label: {
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
            let items = requests.map { request -> NotificationItem in
                var components: DateComponents? = nil
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    components = trigger.dateComponents
                }
                return NotificationItem(id: request.identifier, request: request, dateComponents: components)
            }
            DispatchQueue.main.async {
                self.notifications = items
            }
        }
    }

    func formattedDate(from components: DateComponents?) -> String {
        guard let components = components,
              let date = Calendar.current.date(from: components) else {
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

// MARK: - Row

private struct NotificationRowView: View {
    let item: NotificationItem
    let dateText: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon reflects trigger type (calendar vs generic)
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                Image(systemName: item.dateComponents == nil ? "bell" : "calendar")
                    .imageScale(.large)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 6) {
                Text(item.request.content.title)
                    .font(.headline)
                    .lineLimit(2)

                if !item.request.content.body.isEmpty {
                    Text(item.request.content.body)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }

                if item.dateComponents != nil {
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

#Preview {
    NotificationListView()
}

