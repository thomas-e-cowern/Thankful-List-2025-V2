//
//  TimeSchedulerView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/27/25.
//

import SwiftUI

struct TimeSchedulerView: View {
    
    @Binding var selectedTime: Date
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Select Time")
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)

                DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(.wheel)
                    .accessibilityLabel("Reminder time")
                    .accessibilityHint("Adjust hours and minutes for the daily reminder.")
                    .accessibilityIdentifier("Scheduler.TimePicker")

                Text("This reminder will repeat on the days you select below.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .accessibilityHint("Choose days in the next section.")
            }
            .padding(.vertical, 4)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Time selection")
            .accessibilityValue(formattedTime(selectedTime))
        }
    }
    
    private func formattedTime(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "h:mm a"
        return df.string(from: date)
    }
}

#Preview {
    TimeSchedulerView(selectedTime: .constant(Date()))
}
