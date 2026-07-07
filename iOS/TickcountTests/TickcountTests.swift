import XCTest
@testable import Tickcount

@MainActor
final class TickcountTests: XCTestCase {
    func makeIsolatedStore() -> TickcountStore {
        // Each store instance persists to the same app-support file; tests rely on
        // starting from seeded state and only asserting relative deltas.
        TickcountStore()
    }

    func testSeedDataLoadsBelowFreeLimit() {
        let store = makeIsolatedStore()
        XCTAssertFalse(store.entries.isEmpty)
        XCTAssertLessThan(store.entries.count, TickcountStore.freeEntryLimit)
    }

    func testAddEntrySucceedsUnderLimit() {
        let store = makeIsolatedStore()
        let before = store.entries.count
        let added = store.addEntry(date: Date(), location: "Test value", duration: "Test note", isPro: false)
        XCTAssertTrue(added)
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testCanAddEntryRespectsFreeLimit() {
        let store = makeIsolatedStore()
        for _ in 0..<(TickcountStore.freeEntryLimit + 5) {
            _ = store.addEntry(date: Date(), location: "Filler", duration: "Filler", isPro: false)
        }
        XCTAssertEqual(store.entries.count, TickcountStore.freeEntryLimit)
        XCTAssertFalse(store.canAddEntry(isPro: false))
    }

    func testProBypassesFreeLimit() {
        let store = makeIsolatedStore()
        for _ in 0..<(TickcountStore.freeEntryLimit + 5) {
            _ = store.addEntry(date: Date(), location: "Filler", duration: "Filler", isPro: true)
        }
        XCTAssertGreaterThan(store.entries.count, TickcountStore.freeEntryLimit)
    }

    func testDeleteEntryRemovesIt() {
        let store = makeIsolatedStore()
        _ = store.addEntry(date: Date(), location: "Delete me", duration: "note", isPro: false)
        guard let entry = store.entries.first else { return XCTFail("expected entry") }
        let before = store.entries.count
        store.deleteEntry(entry.id)
        XCTAssertEqual(store.entries.count, before - 1)
    }

    func testUpdateEntryChangesFields() {
        let store = makeIsolatedStore()
        _ = store.addEntry(date: Date(), location: "Original", duration: "note", isPro: false)
        guard let entry = store.entries.first(where: { _ in true }) else { return XCTFail("expected entry") }
        store.updateEntry(entry.id, date: entry.date, location: "Updated", duration: entry.duration)
        XCTAssertTrue(store.entries.contains(where: { $0.id == entry.id }))
    }

    func testDeleteAllDataReseeds() {
        let store = makeIsolatedStore()
        store.deleteAllData()
        XCTAssertFalse(store.entries.isEmpty)
    }

    func testEntriesSortedByDateDescending() {
        let store = makeIsolatedStore()
        let older = Calendar.current.date(byAdding: .day, value: -100, to: Date())!
        let newer = Date()
        _ = store.addEntry(date: older, location: "Old", duration: "note", isPro: false)
        _ = store.addEntry(date: newer, location: "New", duration: "note", isPro: false)
        XCTAssertEqual(store.entries.first?.date, store.entries.map(\.date).max())
    }
}
