import Foundation

struct CheckIn: Identifiable, Codable {
    var id: UUID = UUID()
    var habitID: UUID
    var date: Date = Date()
}

