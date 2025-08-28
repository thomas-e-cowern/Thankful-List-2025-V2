//
//  Thankful_List_2025_V2Tests.swift
//  Thankful-List-2025-V2Tests
//
//  Created by Thomas Cowern on 8/18/25.
//

import Testing
import SwiftUI
import SwiftData
@testable import Thankful_List_2025_V2

@MainActor
struct AddThanksTests {

    // MARK: - In-memory SwiftData
    private func makeContext() throws -> ModelContext {
        let config = ModelConfiguration(for: Thanks.self, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Thanks.self, configurations: config)
        return ModelContext(container)
    }

    // MARK: - Harness mirroring your addThanks() logic
    final class Harness {
        init(context: ModelContext, iconRaw: String, colorHex: String) {
            self.modelContext = context
            self.iconRaw = iconRaw
            self.colorHex = colorHex
        }

        private let modelContext: ModelContext
        private let iconRaw: String
        private let colorHex: String

        var path = NavigationPath()
        var isNavigating = false

        @MainActor
        func addThanks() {
            guard !isNavigating else { return }
            isNavigating = true

            let newThanks = Thanks(
                title: "",
                reason: "",
                date: .now,
                isFavorite: false,
                icon: iconRaw,
                color: colorHex
            )
            modelContext.insert(newThanks)

            // Defer to next runloop tick (same as your production code)
            DispatchQueue.main.async {
                withAnimation(.snappy) {
                    self.path.append(newThanks)
                }
                self.isNavigating = false
            }
        }
    }

    // MARK: - Helpers
    private func fetchThanks(_ context: ModelContext) throws -> [Thanks] {
        try context.fetch(FetchDescriptor<Thanks>())
    }

    /// Allow the main-queue async block to run.
    private func awaitDeferredMainWork() async {
        await Task.yield()
        // tiny delay to ensure the DispatchQueue.main.async block executes
        try? await Task.sleep(nanoseconds: 20_000_000) // 20 ms
    }

    // MARK: - Tests

    @Test
    func addThanks_inserts_and_navigates_once() async throws {
        let context = try makeContext()
        let harness = Harness(context: context, iconRaw: "heart", colorHex: "#112233")

        #expect(try fetchThanks(context).count == 0)
        #expect(harness.path.count == 0)
        #expect(harness.isNavigating == false)

        harness.addThanks()
        #expect(harness.isNavigating == true) // guard engaged immediately

        await awaitDeferredMainWork()

        let items = try fetchThanks(context)
        #expect(items.count == 1)
        #expect(harness.path.count == 1)
        #expect(harness.isNavigating == false)

        if let inserted = items.first {
            #expect(inserted.icon == "heart")
            #expect(inserted.color == "#112233")
            #expect(inserted.isFavorite == false)
            #expect(inserted.title == "")
            #expect(inserted.reason == "")
        } else {
            Issue.record("Expected one inserted Thanks, found none.")
        }
    }

    @Test
    func addThanks_reentrancy_guard_prevents_double_insert() async throws {
        let context = try makeContext()
        let harness = Harness(context: context, iconRaw: "star", colorHex: "#AABBCC")

        harness.addThanks()
        harness.addThanks() // should be ignored while navigating

        await awaitDeferredMainWork()

        #expect(try fetchThanks(context).count == 1)
        #expect(harness.path.count == 1)
        #expect(harness.isNavigating == false)
    }
}
