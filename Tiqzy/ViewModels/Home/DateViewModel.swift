import SwiftUI
import Combine

/// ViewModel to handle date-related logic for the calendar.
class DateViewModel: ObservableObject {
    @Published var currentMonth: Date // The currently displayed month.
    @Published var selectedDate: Date? // The selected date, if any.

    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter

    init() {
        self.currentMonth = calendar.startOfDay(for: Date())
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd" // Format for selected dates.
    }

    /// Generates a grid of days for the current month, including padding.
    func generateDaysForMonth() -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: currentMonth),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)) else {
            return []
        }

        let emptySlots = (calendar.component(.weekday, from: firstDay) - calendar.firstWeekday + 7) % 7
        let daysInMonth = range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: firstDay)
        }

        return Array(repeating: nil, count: emptySlots) + daysInMonth
    }

    /// Moves to the previous month.
    func goToPreviousMonth() {
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }

    /// Moves to the next month.
    func goToNextMonth() {
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }

    /// Checks if a date is today.
    func isToday(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: Date())
    }

    /// Checks if a date is selected.
    func isSelected(_ date: Date) -> Bool {
        selectedDate.map { calendar.isDate(date, inSameDayAs: $0) } ?? false
    }

    /// Selects a date.
    func handleDateSelection(_ date: Date) {
        selectedDate = date
    }

    /// Returns the selected date as a formatted string.
    func getFormattedSelectedDate() -> String? {
        selectedDate.map { dateFormatter.string(from: $0) }
    }
}
