//
//  AddEditThanksView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/20/25.
//

import SwiftUI
import SwiftData
import TipKit
import PhotosUI

struct AddEditThanksView: View {

    @Environment(\.modelContext) var modelContext
    @Binding var navigationPath: NavigationPath
    @State private var selectedItem: PhotosPickerItem?

    var thanks: Thanks
    var selectedColor: Color = .blue

    // Bind the model's hex color to a Color picker
    private var colorBinding: Binding<Color> {
        Binding<Color>(
            get: { Color(hex: self.thanks.color) ?? .white }, // fallback
            set: { newValue in
                self.thanks.color = newValue.toHexString() ?? "#FFFFFF" // fallback
            }
        )
    }

    var body: some View {

        @Bindable var thanks = thanks

        Form {
            // MARK: - Basic Information
            Section("Basic Information") {
                TextField("What are you thankful for?", text: $thanks.title)
                    .accessibilityLabel("Title")
                    .accessibilityHint("Describe what you are thankful for.")
                    .accessibilityIdentifier("AddEditThanks.Title")

                TextField("Why are you thankful for this?", text: $thanks.reason)
                    .accessibilityLabel("Reason")
                    .accessibilityHint("Explain why you are thankful for it.")
                    .accessibilityIdentifier("AddEditThanks.Reason")

                // Favorite control (keeps your button UI, exposes selected state)
                HStack {
                    Text("Mark as favorite")
                        .accessibilityHidden(true) // we'll provide a better label on the button

                    Spacer()

                    Button {
                        thanks.isFavorite.toggle()
                    } label: {
                        (thanks.isFavorite ? Image(systemName: "heart.fill")
                                           : Image(systemName: "heart"))
                            .foregroundStyle(.red)
                            .accessibilityHidden(true) // avoid reading raw glyph
                    }
                    .accessibilityLabel("Favorite")
                    .accessibilityHint(thanks.isFavorite ? "Double-tap to remove from favorites."
                                                         : "Double-tap to add to favorites.")
                    .accessibilityValue(thanks.isFavorite ? "On" : "Off")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityAddTraits(thanks.isFavorite ? .isSelected : [])
                    .accessibilityIdentifier("AddEditThanks.FavoriteButton")
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Favorite")
                .accessibilityValue(thanks.isFavorite ? "On" : "Off")
            }

            // MARK: - Preview
            Section("How your Icon will look based on selections below") {
                HStack(alignment: .center) {
                    Spacer()
                    Image(systemName: thanks.icon)
                        .foregroundStyle(thanks.hexColor)
                        .font(.title)
                        .accessibilityLabel("Icon preview")
                        .accessibilityValue("\(spokenIconName(thanks.icon)), color \(thanks.color.uppercased())")
                        .accessibilityIdentifier("AddEditThanks.IconPreview")
                    Spacer()
                }
            }

            // MARK: - Icon and Colors
            Section("Icon and Colors") {
                Picker("Choose an Icon", selection: $thanks.icon) {
                    ForEach(IconImages.allCases, id: \.self) { icon in
                        IconPickerItemView(icon: icon.rawValue)
                            .tag(icon.rawValue)
                            .foregroundStyle(thanks.hexColor)
                            .accessibilityLabel(spokenIconName(icon.rawValue))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .accessibilityLabel("Choose an icon")
                .accessibilityValue(spokenIconName(thanks.icon))
                .accessibilityIdentifier("AddEditThanks.IconPicker")

                ColorPicker("Choose a color", selection: colorBinding)
                    .accessibilityLabel("Choose a color")
                    .accessibilityValue(thanks.color.uppercased())
                    .accessibilityHint("Double-tap to adjust the color used for the icon.")
                    .accessibilityIdentifier("AddEditThanks.ColorPicker")
            }

            // MARK: - Photo
            Section("Add a photo") {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select a photo", systemImage: "person")
                }
                .accessibilityLabel("Select a photo")
                .accessibilityHint("Opens your photo library to choose an image.")
                .accessibilityValue((selectedItem != nil || thanks.photo != nil) ? "Photo selected" : "No photo selected")
                .accessibilityIdentifier("AddEditThanks.PhotosPicker")

                if let imageData = thanks.photo, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .accessibilityLabel("Selected photo")
                        .accessibilityIdentifier("AddEditThanks.SelectedPhoto")
                }
            }
        }
        .accessibilityLabel("Add or edit gratitude item")
        .accessibilityHint("Fill in basic information, choose an icon and color, and optionally add a photo.")
        .onDisappear {
            if thanks.title.isEmpty {
                modelContext.delete(thanks)
            } else {
                do {
                    try modelContext.save()
                } catch {
                    print("Unable to save context: \(error)")
                }
            }
        }
        .onChange(of: selectedItem, loadPhoto)
    }

    // MARK: - Actions
    func loadPhoto() {
        Task { @MainActor in
            thanks.photo = try await selectedItem?.loadTransferable(type: Data.self)
        }
    }

    // MARK: - A11y helpers
    private func spokenIconName(_ symbol: String) -> String {
        // Turn SF Symbol name into something readable, e.g. "star.fill" -> "star fill"
        symbol
            .replacingOccurrences(of: ".", with: " ")
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
    }
}


#Preview {
    do {
        let previewer = try Previewer()
        
        return AddEditThanksView(navigationPath: .constant(NavigationPath()), thanks: previewer.thanks)
            .modelContainer(previewer.container)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
