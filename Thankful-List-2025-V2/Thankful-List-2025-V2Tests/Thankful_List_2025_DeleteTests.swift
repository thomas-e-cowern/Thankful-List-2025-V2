//
//  Thankful_List_2025_DeleteTests.swift
//  Thankful-List-2025-V2Tests
//
//  Created by Thomas Cowern on 8/28/25.
//

import Testing
import SwiftUI
import SwiftData
@testable import Thankful_List_2025_V2

@MainActor
struct ThanksDeletionTests {
    
    // MARK: - In-memory SwiftData
    private func makeContext() throws -> ModelContext {
        let config = ModelConfiguration(for: Thanks.self, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Thanks.self, configurations: config)
        return ModelContext(container)
    }
    
    // MARK: - Helpers
    @discardableResult
    private func insertThanks(
        _ context: ModelContext,
        title: String,
        reason: String = "",
        icon: String = "heart",
        color: String = "#112233",
        isFavorite: Bool = false,
        date: Date = .now
    ) -> Thanks {
        let t = Thanks(title: title, reason: reason, date: date, isFavorite: isFavorite, icon: icon, color: color)
        context.insert(t)
        return t
    }
    
    private func fetchThanks(_ context: ModelContext) throws -> [Thanks] {
        try context.fetch(FetchDescriptor<Thanks>())
    }
    
    // MARK: - Tests
    
    @Test
    func delete_single_item_by_reference() throws {
        let context = try makeContext()
        
        // Seed three distinct items
        let t1 = insertThanks(context, title: "T1", icon: "sun.max", color: "#AAAAAA")
        let t2 = insertThanks(context, title: "T2", icon: "moon", color: "#BBBBBB")
        let t3 = insertThanks(context, title: "T3", icon: "cloud", color: "#CCCCCC")
        
        #expect(try fetchThanks(context).count == 3)
        
        // Act: delete the middle one
        context.delete(t2)
        
        // Assert
        let remaining = try fetchThanks(context)
        #expect(remaining.count == 2)
        let titles = Set(remaining.map { $0.title })
        #expect(titles.contains("T1"))
        #expect(titles.contains("T3"))
        #expect(!titles.contains("T2"))
    }
    
    @Test
    func delete_all_items_clears_store() throws {
        let context = try makeContext()
        
        insertThanks(context, title: "A")
        insertThanks(context, title: "B")
        insertThanks(context, title: "C")
        #expect(try fetchThanks(context).count == 3)
        
        // Act: delete-all (simple loop; SwiftData does not expose batch delete)
        for item in try fetchThanks(context) {
            context.delete(item)
        }
        
        // Assert: empty
        #expect(try fetchThanks(context).isEmpty)
    }
    
    @Test
    func delete_filtered_items_only_removes_matching() throws {
        let context = try makeContext()
        
        // Seed favorites vs non-favorites
        insertThanks(context, title: "Fav 1", icon: "star", color: "#FFD700", isFavorite: true)
        insertThanks(context, title: "Fav 2", icon: "star", color: "#FFD700", isFavorite: true)
        insertThanks(context, title: "NonFav 1", icon: "heart", color: "#FF0000", isFavorite: false)
        insertThanks(context, title: "NonFav 2", icon: "heart", color: "#FF0000", isFavorite: false)
        
        #expect(try fetchThanks(context).count == 4)
        
        // Act: delete only non-favorites
        let all = try fetchThanks(context)
        for item in all where item.isFavorite == false {
            context.delete(item)
        }
        
        // Assert: only favorites remain
        let remaining = try fetchThanks(context)
        #expect(remaining.count == 2)
        #expect(remaining.allSatisfy { $0.isFavorite })
        let titles = Set(remaining.map { $0.title })
        #expect(titles == ["Fav 1", "Fav 2"])
    }
    
    @Test
    func deleting_same_instance_twice_is_harmless() throws {
        let context = try makeContext()
        
        let t = insertThanks(context, title: "Once")
        #expect(try fetchThanks(context).count == 1)
        
        // First delete
        context.delete(t)
        #expect(try fetchThanks(context).count == 0)
        
        // Second delete should be a no-op (should not crash)
        context.delete(t)
        #expect(try fetchThanks(context).count == 0)
    }
}
