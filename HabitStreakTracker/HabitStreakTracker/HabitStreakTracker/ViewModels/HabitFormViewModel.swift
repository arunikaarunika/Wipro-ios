
import Foundation

@MainActor
final class HabitFormViewModel: ObservableObject {

    enum Mode {
        case add
        case edit(Habit)
    }

    static let nameLimit = 40
    static let noteLimit = 140

    @Published var name: String {
        didSet {
            if name.count > Self.nameLimit { name = String(name.prefix(Self.nameLimit)) }
        }
    }
    @Published var note: String {
        didSet {
            if note.count > Self.noteLimit { note = String(note.prefix(Self.noteLimit)) }
        }
    }
    @Published var category: HabitCategory
    @Published var frequency: HabitFrequency
    @Published var startDate: Date
    @Published var hasEndDate: Bool
    @Published var endDate: Date
    @Published var reminderEnabled: Bool
    @Published var reminderTime: Date
    /// True when the user switched notifications off for this app in Settings.
    @Published var notificationsDenied = false
    @Published var errorMessage: String?

    let mode: Mode

    init(mode: Mode) {
        self.mode = mode
        switch mode {
        case .add:
            name = ""
            note = ""
            category = .health
            frequency = .daily
            startDate = Date()
            hasEndDate = true
            endDate = Date().addingDays(30)
            reminderEnabled = true
            reminderTime = Habit.time(hour: 9, minute: 0)
        case .edit(let habit):
            name = habit.name
            note = habit.note
            category = habit.category
            frequency = habit.frequency
            startDate = habit.startDate
            hasEndDate = habit.endDate != nil
            endDate = habit.endDate ?? max(habit.startDate, Date()).addingDays(30)
            reminderEnabled = habit.reminderEnabled
            reminderTime = habit.reminderTime
        }
    }

    var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }

    var title: String { isEditing ? "Edit Habit" : "New Habit" }

    
    var earliestEndDate: Date {
        if case .edit(let habit) = mode { return habit.startDate.startOfDay }
        return startDate.startOfDay
    }

    
    func requestNotificationPermission() async {
        guard reminderEnabled else {
            notificationsDenied = false
            return
        }
        let granted = await ReminderService.requestAuthorization()
        notificationsDenied = !granted
    }

    
    func makeHabit(existing: [Habit]) -> Habit? {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter a habit name."
            return nil
        }

        var editingID: UUID?
        if case .edit(let habit) = mode { editingID = habit.id }

        let isDuplicate = existing.contains {
            $0.id != editingID && $0.name.caseInsensitiveCompare(trimmedName) == .orderedSame
        }
        guard !isDuplicate else {
            errorMessage = "A habit with this name already exists."
            return nil
        }

        let lastDay: Date? = hasEndDate ? endDate.startOfDay : nil
        if let lastDay, lastDay < earliestEndDate {
            errorMessage = "End date must be on or after the start date."
            return nil
        }

        errorMessage = nil

        let time = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let hour = time.hour ?? 9
        let minute = time.minute ?? 0

        switch mode {
        case .add:
            return Habit(name: trimmedName,
                         category: category,
                         frequency: frequency,
                         startDate: startDate.startOfDay,
                         endDate: lastDay,
                         note: trimmedNote,
                         reminderEnabled: reminderEnabled,
                         reminderHour: hour,
                         reminderMinute: minute)
        case .edit(var habit):
            habit.name = trimmedName
            habit.category = category
            habit.frequency = frequency
            habit.note = trimmedNote
            habit.endDate = lastDay
            habit.reminderEnabled = reminderEnabled
            habit.reminderHour = hour
            habit.reminderMinute = minute
            return habit
        }
    }
}
