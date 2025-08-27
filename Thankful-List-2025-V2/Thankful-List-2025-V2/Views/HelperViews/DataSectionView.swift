//
//  DataSectionView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/27/25.
//

import SwiftUI

struct DataSectionView: View {
    @Binding var showAlert: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 10) {
                Image(systemName: "tray.full")
                    .imageScale(.large)
                    .accessibilityHidden(true)
                Text("Data")
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
            }

            // Description
            Text("The button below will erase all your data and start fresh.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // Caution Box
            VStack(alignment: .leading, spacing: 6) {
                Text("Caution")
                    .font(.title3).bold()
                    .accessibilityAddTraits(.isHeader)
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
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Caution. This action erases all data. It cannot be undone.")

            // Destructive Button
            Button(role: .destructive) {
                showAlert.toggle()
            } label: {
                Label("Erase Data", systemImage: "trash")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity) // expands to fill width
            }
            .buttonStyle(.borderedProminent)
            .accessibilityLabel("Erase all data")
            .accessibilityHint("Shows a confirmation alert. This action cannot be undone.")
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.gray.opacity(0.15)))
        .accessibilityElement(children: .contain)
        .accessibilitySortPriority(1)
        .accessibilityLabel("Data section")
        .accessibilityHint("Erase all stored items.")
    }
}

#Preview {
    DataSectionView(showAlert: .constant(false))
}
