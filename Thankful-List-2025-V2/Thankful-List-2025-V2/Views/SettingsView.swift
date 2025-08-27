//
//  SettingsView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/20/25.
//

import SwiftUI
import SwiftData
import TipKit

struct SettingsView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var path = NavigationPath()
    @Query var thanks: [Thanks]

    @State private var showNotificationSchedular: Bool = false
    @State private var showScheduledNotifications: Bool = false
    @State private var isTipVisible = true
    @State private var showAlert = false

    let settingsTip = SettingsTip()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // Decorative background – hide from accessibility
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()
                .accessibilityHidden(true)

                ScrollView {
                    VStack(spacing: 20) {

                        // TipKit card (animated)
                        TipCardView(isTipVisible: $isTipVisible, tip: settingsTip)

                        // Notifications card
                        NotificationsSectionView(showNotificationSchedular: $showNotificationSchedular, showScheduledNotifications: $showScheduledNotifications)

                        // Data / destructive actions card
                        DataSectionView(showAlert: $showAlert)

                        Spacer(minLength: 8)
                    }
                    .frame(maxWidth: 560)
                    .padding(.horizontal)
                    .padding(.vertical, 16)
                }
                // Give the scroll view a clear purpose for rotor users
                .accessibilityLabel("Settings content")
                .accessibilityHint("Scroll to review tip, notification options, and data actions.")
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Delete all data? This is irreversible.", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) { dismiss() }
                    .accessibilityLabel("Cancel")
                Button("Delete All Data", role: .destructive) { deleteAllData() }
                    .accessibilityLabel("Confirm delete all data")
                    .accessibilityHint("Deletes all items immediately.")
            }
            .sheet(isPresented: $showNotificationSchedular) {
                NotificationSchedulerView()
                    .accessibilityAddTraits(.isModal)
                    .accessibilityLabel("Notification Scheduler")
                    .accessibilityHint("Pick days and times for reminders.")
            }
            .sheet(isPresented: $showScheduledNotifications) {
                NotificationListView()
                    .accessibilityAddTraits(.isModal)
                    .accessibilityLabel("Scheduled Notifications")
                    .accessibilityHint("Review and edit existing reminders.")
            }
            .navigationDestination(for: Thanks.self) { thank in
                AddEditThanksView(navigationPath: $path, thanks: thank)
            }
            .addThanksToolbar(path: $path)
        }
    }

    // MARK: - Data
    private func deleteAllData() {
        do {
            try modelContext.delete(model: Thanks.self)
        } catch {
            fatalError("Error deleting data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SettingsView()
        .task {
            try? Tips.resetDatastore()
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
}
