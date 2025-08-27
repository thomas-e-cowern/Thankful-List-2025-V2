//
//  NotificationSchedulerView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/21/25.
//

import SwiftUI
import TipKit
import UserNotifications

struct NotificationSchedulerView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var selectedTime = Date()
    @State private var selectedDays: Set<String> = []

    private let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    var body: some View {
        NavigationView {
            ZStack {
                // Decorative background
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()
                .accessibilityHidden(true)

                Form {
                    // MARK: Time
                    TimeSchedulerView(selectedTime: $selectedTime)

                    // MARK: Days
                    DaysSchedulerView(selectedDays: $selectedDays)

                    // MARK: Actions
                    Section {
                        Button {
                            requestNotificationPermission()
                            scheduleNotifications()
                            dismiss()
                        } label: {
                            Label("Schedule Notifications", systemImage: "calendar.badge.plus")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .accessibilityLabel("Schedule notifications")
                        .accessibilityHint("Creates repeating reminders for the selected time and days.")
                        .accessibilityIdentifier("Scheduler.ScheduleButton")

                        Button(role: .cancel) {
                            dismiss()
                        } label: {
                            Label("Cancel", systemImage: "xmark")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .accessibilityLabel("Cancel")
                        .accessibilityHint("Close without scheduling.")
                        .accessibilityIdentifier("Scheduler.CancelButton")
                    } footer: {
                        Text(summaryText)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                            .accessibilityIdentifier("Scheduler.Summary")
                            .accessibilityLabel("Summary")
                            .accessibilityValue(summaryText)
                    }
                }
                .scrollContentBackground(.hidden)
                .accessibilityLabel("Notification scheduler form")
                .accessibilityHint("Set a time and select days for repeating reminders.")
            }
            .navigationTitle("Reminder Scheduler")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - UI helpers
    private var summaryText: String {
        let timeString = formattedTime(selectedTime)
        if selectedDays.isEmpty {
            return "No days selected yet. Reminders will repeat at \(timeString) on any days you choose."
        } else {
            let list = selectedDays.sorted(by: sortWeekday).joined(separator: ", ")
            return "Reminders will repeat at \(timeString) on: \(list)."
        }
    }

    private func formattedTime(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "h:mm a"
        return df.string(from: date)
    }

    private func sortWeekday(_ a: String, _ b: String) -> Bool {
        guard
            let ia = daysOfWeek.firstIndex(of: a),
            let ib = daysOfWeek.firstIndex(of: b)
        else { return a < b }
        return ia < ib
    }

    // MARK: - Request and Schedule
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, error in
            if let error = error { print("Permission error: \(error)") }
        }
    }

    private func scheduleNotifications() {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: selectedTime)
        let minute = calendar.component(.minute, from: selectedTime)

        for day in selectedDays {
            guard let weekday = daysOfWeek.firstIndex(of: day)?.advanced(by: 1) else { continue }

            var dateComponents = DateComponents()
            dateComponents.weekday = weekday // 1 = Sunday, 7 = Saturday
            dateComponents.hour = hour
            dateComponents.minute = minute

            let content = UNMutableNotificationContent()
            content.title = "from your Thankful list"
            content.body = "Isn't there something you're thankful for?"
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let identifier = "\(day)-\(hour)-\(minute)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error { print("Scheduling error: \(error)") }
            }
        }
    }
}

// MARK: - Chip Toggle Style (accessible)
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

#Preview {
    NotificationSchedulerView()
}
