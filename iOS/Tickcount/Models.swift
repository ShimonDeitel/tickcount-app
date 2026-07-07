import Foundation

struct TickcountEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var location: String
    var duration: String
}
