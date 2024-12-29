import SwiftUI
import Combine

class DateViewModel: ObservableObject {
    @Published var currentMonth: Date
    @Published var selectedStartDate: Date?
    @Published var selectedEndDate: Date?

    private let calendar = Calendar.current

    init() {
        self.currentMonth = calendar.startOfDay(for: Date())
    }

    // Generate days for the current month with padding for empty slots
    func generateDaysForMonth() -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: currentMonth),
              let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)) else {
            return []
        }

        // Determine how many empty slots to prepend for alignment
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let emptySlots = (firstWeekday - calendar.firstWeekday + 7) % 7

        // Generate the dates for the current month
        let daysInMonth = range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)
        }

        // Add nils for empty slots and append valid dates
        return Array(repeating: nil, count: emptySlots) + daysInMonth
    }

    // Move to the previous month
    func goToPreviousMonth() {
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }

    // Move to the next month
    func goToNextMonth() {
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }

    // Check if a date is today
    func isToday(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: Date())
    }

    // Check if a date is selected
    func isSelected(_ date: Date) -> Bool {
        if let start = selectedStartDate, let end = selectedEndDate {
            return date >= start && date <= end
        } else if let start = selectedStartDate {
            return calendar.isDate(date, inSameDayAs: start)
        }
        return false
    }

    // Handle date selection logic
    func handleDateSelection(_ date: Date) {
        if let start = selectedStartDate, let end = selectedEndDate {
            selectedStartDate = date
            selectedEndDate = nil
        } else if let start = selectedStartDate {
            if date < start {
                selectedStartDate = date
            } else {
                selectedEndDate = date
            }
        } else {
            selectedStartDate = date
        }
    }
}
