//
//  EraseAllDatButton.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/27/25.
//

import SwiftUI

struct EraseAllDataButton: View {
    
    @Binding var showAlert: Bool

        var body: some View {
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
}

#Preview {
    EraseAllDataButton(showAlert: .constant(false))
}
