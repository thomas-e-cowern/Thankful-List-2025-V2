//
//  ListThanksView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/20/25.
//

import SwiftUI
import SwiftData
import TipKit

struct ListThanksView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var path = NavigationPath()
    
    // Initial fetch is sorted; we’ll still re-sort in-memory so user sort changes are instant.
    @Query private var thanks: [Thanks]
    
    @State private var searchText = ""
    @State private var sortOption: ThanksSortOption = .titleAsc
    
    let addSortTip = AddSortTip()
    
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
            .navigationTitle("Thanks List")
            .navigationDestination(for: Thanks.self) { thank in
                AddEditThanksView(navigationPath: $path, thanks: thank)
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search favorites")
            .withSortToolbar(
                selection: $sortOption,
                labelForOption: { $0.label },
            )
//            .popoverTip(addSortTip)
            .overlay {
                if displayedThanks.isEmpty {
                    ContentUnavailableView(
                        "No thanks yet",
                        systemImage: "heart",
                        description: Text("Tap the + button to add a thanks")
                    )
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(Text("No thanks yet"))
                    .accessibilityValue(Text("Tap the Add button to add a thanks"))
                    .accessibilityHint(Text("Double-tap to start adding."))
                    .accessibilityAddTraits(.isButton) // advertise it's actionable
                    .accessibilityIdentifier("EmptyState.Thanks")
                    .accessibilityAction(named: "Add a thanks") {
                        // call your add handler here, e.g.:
                        // isPresentingAddSheet = true
                    }
                }
            }
            .addThanksToolbar(path: $path)
        }
    }
    
    // MARK: - Derived Data
    
    private var displayedThanks: [Thanks] {
        
        if searchText.isEmpty {
            return thanks.sorted(using: sortOption.descriptors)
        } else {
            let searchedBox = thanks.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.reason.lowercased().contains(searchText.lowercased())
            }
            
            return searchedBox.sorted(using: sortOption.descriptors)
        }
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
    ListThanksView(sort: SortDescriptor(\Thanks.title))
        .task {
            try? Tips.resetDatastore()
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
}
