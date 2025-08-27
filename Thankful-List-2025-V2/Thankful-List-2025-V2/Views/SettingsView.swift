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
//                        VStack(alignment: .leading, spacing: 16) {
//                            HStack(spacing: 10) {
//                                Image(systemName: "bell.badge")
//                                    .imageScale(.large)
//                                    .accessibilityHidden(true) // icon is decorative, text conveys meaning
//                                Text("Notifications")
//                                    .font(.headline)
//                                    .accessibilityAddTraits(.isHeader)
//                            }
//
//                            VStack(spacing: 10) {
//                                Button {
//                                    showNotificationSchedular.toggle()
//                                } label: {
//                                    Label("Schedule Notifications", systemImage: "calendar.badge.plus")
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                }
//                                .buttonStyle(.borderedProminent)
//                                .accessibilityLabel("Schedule notifications")
//                                .accessibilityHint("Opens the scheduler to pick times and days.")
//
//                                Button {
//                                    showScheduledNotifications.toggle()
//                                } label: {
//                                    Label("See Scheduled Notifications", systemImage: "list.bullet.rectangle")
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                }
//                                .buttonStyle(.bordered)
//                                .accessibilityLabel("See scheduled notifications")
//                                .accessibilityHint("Shows a list of notifications that are already scheduled.")
//                            }
//                        }
//                        .padding(16)
//                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
//                        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.gray.opacity(0.15)))
//                        // Treat the card as a region and read its children together
//                        .accessibilityElement(children: .contain)
//                        .accessibilitySortPriority(2)
//                        .accessibilityLabel("Notifications section")
//                        .accessibilityHint("Manage scheduling and review existing notifications.")
//                        .accessibilityAddTraits(.isSummaryElement)

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
//            .accessibilityNavigationStyle(.automatic) // lets iOS choose the best behavior for assistive tech
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
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        let newThanks = Thanks(
//                            title: "",
//                            reason: "",
//                            date: .now,
//                            isFavorite: false,
//                            icon: IconImages.star.rawValue,
//                            color: "#007AFF"
//                        )
//                        modelContext.insert(newThanks)
//                        path.append(newThanks)
//                    } label: {
//                        Image(systemName: "plus")
//                            .imageScale(.large)
//                            .accessibilityHidden(true) // hide the raw glyph; provide a better label on the button itself
//                    }
//                    .accessibilityLabel("Add new gratitude entry")
//                    .accessibilityHint("Creates a new item and opens it for editing.")
//                }
//            }
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

