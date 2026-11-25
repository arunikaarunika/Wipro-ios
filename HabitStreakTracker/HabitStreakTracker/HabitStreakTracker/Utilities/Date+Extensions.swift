
import Foundation

extension Date {
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

   
    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }

    
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}
