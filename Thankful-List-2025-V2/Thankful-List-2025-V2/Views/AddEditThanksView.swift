//
//  AddEditThanksView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/20/25.
//

import SwiftUI
import PhotosUI

struct AddEditThanksView: View {
    
    @Environment(\.modelContext) var modelContext
    @Binding var navigationPath: NavigationPath
    @State private var selectedItem: PhotosPickerItem?
    
    var thanks: Thanks
    var selectedColor: Color = .blue
    
    private var colorBinding: Binding<Color> {
        Binding<Color>(
            get: { Color(hex: self.thanks.color) ?? .white }, // Fallback to white if conversion fails
            set: { newValue in
                self.self.thanks.color = newValue.toHexString() ?? "#FFFFFF" // Fallback to white hex string
            }
        )
    }
    
    var body: some View {
        
        @Bindable var thanks = thanks
        
        Form {
            Section("Basic Information") {
                TextField("What are you thankful for?", text: $thanks.title)
                
                TextField("Why are you thankful for this?", text: $thanks.reason)
                
                HStack {
                    Text("Mark as favorite")
                    
                    Spacer()
                    
                    Button {
                        thanks.isFavorite.toggle()
                    } label: {
                        thanks.isFavorite ? Image(systemName: "heart.fill") : Image(systemName: "heart")
                        
                    }
                    .foregroundStyle(.red)
                }
            }
            
            Section("How your Icon will look based on selections below") {
                HStack(alignment: .center) {
                    Spacer()
                    Image(systemName: thanks.icon)
                        .foregroundStyle(thanks.hexColor)
                        .font(.title)
                    Spacer()
                }
            }
            
            Section("Icon and Colors") {
                Picker("Choose an Icon", selection: $thanks.icon) {
                    ForEach(IconImages.allCases, id: \.self) { icon in
                        
                        IconPickerItemView(icon: icon.rawValue)
                            .tag(icon.rawValue)
                        
                    }
                    .foregroundStyle(thanks.hexColor)
                }
                .pickerStyle(WheelPickerStyle())
                
                ColorPicker("Choose a color", selection: colorBinding)
            }
            
            Section("Add a photo") {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select a photo", systemImage: "person")
                }
                
                if let imageData = thanks.photo, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
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
    
    func loadPhoto() {
        Task { @MainActor in
            thanks.photo = try await selectedItem?.loadTransferable(type: Data.self)
        }
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
