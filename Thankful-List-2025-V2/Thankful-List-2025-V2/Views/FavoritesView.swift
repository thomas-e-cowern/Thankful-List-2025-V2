//
//  FsvoritesView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/21/25.
//

import SwiftUI
import SwiftData
import TipKit

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var path = NavigationPath()
    
    // Initial fetch is sorted; we’ll still re-sort in-memory so user sort changes are instant.
    @Query private var thanks: [Thanks]
    
    @State private var searchText = ""
    @State private var sortOption: ThanksSortOption = .titleAsc
    
    private let addFavoritesTip = AddFavoritesTip()
    
    init(sort: SortDescriptor<Thanks>) {
        _thanks = Query(sort: [sort])
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(displayedThanks) { thank in
                    NavigationLink(value: thank) {
                        AccessibleThanksRow(thank: thank)
                    }
                }
                .onDelete(perform: deleteThanks)
            }
            .animation(.default, value: displayedThanks)
            .navigationTitle("Favorites List")
            .navigationDestination(for: Thanks.self) { thank in
                AddEditThanksView(navigationPath: $path, thanks: thank)
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search favorites")
            .withSortToolbar(
                selection: $sortOption,
                labelForOption: { $0.label },
                tip: nil     // or nil if you don't want a TipKit popover
            )
            .popoverTip(addFavoritesTip)
            .overlay {
                if displayedThanks.isEmpty {
                    ContentUnavailableView(
                        "No favorites yet",
                        systemImage: "heart",
                        description: Text("Tap the + button to add a thanks and make it a favorite")
                    )
                }
            }
            .addThanksToolbar(path: $path)
            
        }
    }
    
    // MARK: - Derived Data
    private var displayedThanks: [Thanks] {
        
        let favorites = thanks.filter { $0.isFavorite }
        let searched = searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        ? favorites
        : favorites.filter { thank in
            let q = searchText.lowercased()
            return thank.title.lowercased().contains(q) ||
            thank.reason.lowercased().contains(q)
        }
        return searched.sorted(using: sortOption.descriptors)
    }
    
    // MARK: - Functions and Methods
    func deleteThanks(at offsets: IndexSet) {
            for offset in offsets {
                let thanks = thanks[offset]
                modelContext.delete(thanks)
                do {
                    try modelContext.save()
                } catch {
                    print("Unable to delete thanks: \(error.localizedDescription)")
                }
            }
        }
    
}

// MARK: - Preview

#Preview("No data") {
    FavoritesView(sort: SortDescriptor(\Thanks.title))
        .task {
            try? Tips.resetDatastore()
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
}
