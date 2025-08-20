//
//  AddEditThanksView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/20/25.
//

import SwiftUI
import PhotosUI

struct EditThanksView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Binding var navigationPath: NavigationPath
    @State private var selectedItem: PhotosPickerItem?

    // MARK: - Mode
    private enum Mode {
        case add
        case edit(original: Thanks)
    }

    private let mode: Mode

    // Local draft so Cancel truly discards changes.
    @State private var draft: Thanks

    // MARK: - Initializers

    /// Use for **adding** a new Thanks
    init(navigationPath: Binding<NavigationPath>) {
        self._navigationPath = navigationPath
        let newDraft = Thanks(
            title: "",
            reason: "",
            date: .now,
            isFavorite: false,
            icon: IconImages.star.rawValue,
            color: "#007AFF"
        )
        self._draft = State(initialValue: newDraft)
        self.mode = .add
    }

    /// Use for **editing** an existing Thanks
    init(navigationPath: Binding<NavigationPath>, thanks: Thanks) {
        self._navigationPath = navigationPath
        // Create a copy using your model's designated init (no photo param)
        let copy = Thanks(
            title: thanks.title,
            reason: thanks.reason,
            date: thanks.date,
            isFavorite: thanks.isFavorite,
            icon: thanks.icon,
            color: thanks.color
        )
        copy.photo = thanks.photo // copy photo explicitly
        self._draft = State(initialValue: copy)
        self.mode = .edit(original: thanks)
    }

    // MARK: - Bindings

    private var colorBinding: Binding<Color> {
        Binding(
            get: { Color(hex: draft.color) ?? .white },
            set: { newValue in draft.color = newValue.toHexString() ?? "#FFFFFF" }
        )
    }

    // MARK: - Body

    var body: some View {
        @Bindable var editable = draft

        Form {
            Section("Basic Information") {
                TextField("What are you thankful for?", text: $editable.title)
                    .textInputAutocapitalization(.sentences)

                TextField("Why are you thankful for this?", text: $editable.reason, axis: .vertical)
                    .textInputAutocapitalization(.sentences)

                Toggle(isOn: $editable.isFavorite) {
                    Label("Mark as favorite", systemImage: editable.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(.red)
                }
            }

            Section("Preview") {
                HStack {
                    Spacer()
                    Image(systemName: editable.icon)
                        .foregroundStyle(editable.hexColor)
                        .font(.largeTitle)
                        .accessibilityHidden(true)
                    Spacer()
                }
            }

            Section("Icon and Color") {
                Picker("Choose an Icon", selection: $editable.icon) {
                    ForEach(IconImages.allCases, id: \.self) { icon in
//                        IconPickerItem(icon: icon.rawValue).tag(icon.rawValue)
                    }
                }
                .pickerStyle(.wheel)

                ColorPicker("Choose a color", selection: colorBinding, supportsOpacity: false)
            }

            Section("Photo") {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select a photo", systemImage: "photo.on.rectangle")
                }

                if let data = editable.photo, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.top, 4)
                }
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismissOrPop() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { handleSave() }
                    .disabled(!canSave)
            }
        }
        .onChange(of: selectedItem) { _, _ in
            loadPhoto()
        }
    }

    // MARK: - Derived

    private var navigationTitle: String {
        switch mode {
        case .add:  return "Add Thanks"
        case .edit: return "Edit Thanks"
        }
    }

    private var canSave: Bool {
        !draft.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Actions

    private func handleSave() {
        switch mode {
        case .add:
            modelContext.insert(draft) // draft already is a Thanks instance
        case .edit(let original):
            // Apply draft changes back to the original
            original.title = draft.title
            original.reason = draft.reason
            original.date = draft.date
            original.isFavorite = draft.isFavorite
            original.icon = draft.icon
            original.color = draft.color
            original.photo = draft.photo
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to save: \(error)")
        }

        dismissOrPop()
    }

    private func dismissOrPop() {
        if !$navigationPath.wrappedValue.isEmpty {
            $navigationPath.wrappedValue.removeLast()
        } else {
            dismiss()
        }
    }

    private func loadPhoto() {
        Task { @MainActor in
            draft.photo = try await selectedItem?.loadTransferable(type: Data.self)
        }
    }
}

// MARK: - Previews

#Preview("Add") {
    EditThanksView(navigationPath: .constant(NavigationPath()))
}
