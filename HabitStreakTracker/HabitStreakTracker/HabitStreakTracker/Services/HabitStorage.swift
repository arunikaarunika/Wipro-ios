

import Foundation

protocol HabitStoring {
    
    func load() -> [Habit]?
    func save(_ habits: [Habit])
}

final class FileHabitStorage: HabitStoring {
    private let fileURL: URL

    init(fileName: String = "habits.json") {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = directory.appendingPathComponent(fileName)
    }

    func load() -> [Habit]? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([Habit].self, from: data)
        } catch {
            print("HabitStorage: failed to load habits – \(error.localizedDescription)")
            return []
        }
    }

    func save(_ habits: [Habit]) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(habits)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("HabitStorage: failed to save habits – \(error.localizedDescription)")
        }
    }
}
