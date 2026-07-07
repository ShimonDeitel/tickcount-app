import SwiftUI

@main
struct TickcountApp: App {
    @StateObject private var store = TickcountStore()
    @StateObject private var purchases = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(purchases)
                .tint(Theme.primary)
        }
    }
}
