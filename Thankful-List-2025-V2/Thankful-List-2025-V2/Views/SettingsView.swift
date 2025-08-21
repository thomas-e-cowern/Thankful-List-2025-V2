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
    @State private var path = NavigationPath()
    @Query var thanks: [Thanks]

    @State private var showNotificationSchedular: Bool = false
    @State private var showScheduledNotifications: Bool = false
    @State private var isTipVisible = true   // track visibility
    @State private var showAlert = false

    let settingsTip = SettingsTip()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // Soft background
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        // TipKit card (animated)
                        if isTipVisible {
                            VStack(alignment: .leading, spacing: 12) {
                                TipView(settingsTip)
                                    .onAppear {
                                        withAnimation(.spring(response: 0.32, dampingFraction: 0.88)) {
                                            isTipVisible = true
                                        }
                                    }
                                    .onDisappear {
                                        // When the tip is dismissed, animate the container away too
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                            isTipVisible = false
                                        }
                                    }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Color.gray.opacity(0.15)))
                            // Smooth in/out
                            .transition(
                                .asymmetric(
                                    insertion: .opacity.combined(with: .scale(scale: 0.98, anchor: .top)),
                                    removal: .opacity.combined(with: .scale(scale: 0.92, anchor: .top))
                                )
                            )
                            .animation(.spring(response: 0.35, dampingFraction: 0.9), value: isTipVisible)
                        }

                        // Notifications card
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 10) {
                                Image(systemName: "bell.badge")
                                    .imageScale(.large)
                                Text("Notifications")
                                    .font(.headline)
                            }

                            VStack(spacing: 10) {
                                Button {
                                    showNotificationSchedular.toggle()
                                } label: {
                                    Label("Schedule Notifications", systemImage: "calendar.badge.plus")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .buttonStyle(.borderedProminent)

                                Button {
                                    showScheduledNotifications.toggle()
                                } label: {
                                    Label("See Scheduled Notifications", systemImage: "list.bullet.rectangle")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .padding(16)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.gray.opacity(0.15)))

                        // Data / destructive actions card
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 10) {
                                Image(systemName: "tray.full")
                                    .imageScale(.large)
                                Text("Data")
                                    .font(.headline)
                            }

                            Text("The button below will erase all your data and start fresh.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Caution")
                                    .font(.title3).bold()
                                Text("This will erase all your data and is irreversible.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.red.opacity(0.08))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.red.opacity(0.2))
                            )

                            HStack(spacing: 12) {
                                Text("Erase all data?")
                                    .font(.subheadline)
                                Spacer()
                                Button(role: .destructive) {
                                    showAlert.toggle()
                                } label: {
                                    Label("Erase Data", systemImage: "trash")
                                        .font(.body.weight(.semibold))
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .padding(16)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.gray.opacity(0.15)))

                        Spacer(minLength: 8)
                    }
                    .frame(maxWidth: 560)
                    .padding(.horizontal)
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Thanks.self) { thanks in
//                EditThanksView(navigationPath: $path, thanks: thanks)
            }
            .alert("Delete all data? This is irreversible.", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) { dismiss() }
                Button("Delete All Data", role: .destructive) { deleteAllData() }
            }
            .sheet(isPresented: $showNotificationSchedular) {
                NotificationSchedulerView()
            }
            .sheet(isPresented: $showScheduledNotifications) {
                NotificationListView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Use a Button for accessibility; functionality unchanged.
                    Button {
                        let newThanks = Thanks(
                            title: "",
                            reason: "", // <- matches your model (no functional change; just the correct label)
                            date: .now,
                            isFavorite: false,
                            icon: IconImages.star.rawValue,
                            color: "#007AFF"
                        )
                        modelContext.insert(newThanks)
                        path.append(newThanks)
                    } label: {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                }
            }
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
