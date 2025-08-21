//
//  NotificationSchedulerView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/21/25.
//

import SwiftUI
import UserNotifications

struct NotificationSchedulerView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var selectedTime = Date()
    @State private var selectedDays: Set<String> = []

    private let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                Form {
                    // Time
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select Time")
                                .font(.headline)

                            DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(.wheel)

                            Text("This reminder will repeat on the days you select below.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }

                    // Days (individually selectable with Toggle + custom style)
                    Section {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select Days")
                                .font(.headline)

                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 8),
                                    GridItem(.flexible(), spacing: 8),
                                    GridItem(.flexible(), spacing: 8)
                                ],
                                spacing: 8
                            ) {
                                ForEach(daysOfWeek, id: \.self) { day in
                                    Toggle(day, isOn: Binding(
                                        get: { selectedDays.contains(day) },
                                        set: { isOn in
                                            if isOn { selectedDays.insert(day) }
                                            else { selectedDays.remove(day) }
                                        }
                                    ))
                                    .toggleStyle(ChipToggleStyle())     // ← key change
                                    .accessibilityLabel(day + (selectedDays.contains(day) ? ", selected" : ""))
                                }
                            }

                            if selectedDays.isEmpty {
                                Text("Tip: choose at least one day to schedule a repeating reminder.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    // Actions
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

                        Button(role: .cancel) {
                            dismiss()
                        } label: {
                            Label("Cancel", systemImage: "xmark")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    } footer: {
                        Text(summaryText)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                    }
                }
                .scrollContentBackground(.hidden)
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

    // MARK: - Original functionality (unchanged)

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

private struct ChipToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
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
        .buttonStyle(.plain) // important to avoid extra row selection behavior inside Form
        .contentShape(Rectangle())
    }
}

#Preview {
    NotificationSchedulerView()
}
