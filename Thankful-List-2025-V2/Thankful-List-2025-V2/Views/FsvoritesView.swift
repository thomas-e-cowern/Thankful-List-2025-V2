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
    @State private var sortOption: SortOption = .titleAsc

    private let addThanksTip = AddThanksTip()

    init(sort: SortDescriptor<Thanks>) {
        _thanks = Query(sort: [sort])
    }

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(displayedThanks) { thank in
                    NavigationLink(value: thank) {
                        ThanksRowView(thanks: thank)
                    }
                }
            }
            .animation(.default, value: displayedThanks)
            .navigationTitle("Thanks List")
            .navigationDestination(for: Thanks.self) { thank in
                AddEditThanksView(navigationPath: $path, thanks: thank)
                Text("Edit view for: \(thank.title)")
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search favorites")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Picker("Sort", selection: $sortOption) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.label).tag(option)
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let newThanks = Thanks(
                            title: "",
                            reason: "",
                            date: .now,
                            isFavorite: false,
                            icon: IconImages.star.rawValue,
                            color: "#007AFF"
                        )
                        modelContext.insert(newThanks)
                        path.append(newThanks)
                        print("Current thanks count: \(thanks.count)")
                    } label: {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                    .popoverTip(addThanksTip)
                    .accessibilityLabel("Add new Thanks")
                    .accessibilityHint("Opens the form to add a new gratitude entry.")
                }
            }
            .overlay {
                if displayedThanks.isEmpty {
                    ContentUnavailableView(
                        "No thanks yet",
                        systemImage: "heart",
                        description: Text("Tap the + button to add a thanks")
                    )
                }
            }
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
}

// MARK: - Sorting

private enum SortOption: CaseIterable {
    case titleAsc, titleDesc, dateAsc, dateDesc

    var label: String {
        switch self {
        case .titleAsc:  return "Name A → Z"
        case .titleDesc: return "Name Z → A"
        case .dateAsc:   return "Date Oldest → Newest"
        case .dateDesc:  return "Date Newest → Oldest"
        }
    }

    var descriptors: [SortDescriptor<Thanks>] {
        switch self {
        case .titleAsc:
            [SortDescriptor(\Thanks.title, order: .forward)]
        case .titleDesc:
            [SortDescriptor(\Thanks.title, order: .reverse)]
        case .dateAsc:
            [SortDescriptor(\Thanks.date)]
        case .dateDesc:
            [SortDescriptor(\Thanks.date, order: .reverse)]
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
