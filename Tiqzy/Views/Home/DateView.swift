import SwiftUI

/// A view for selecting a date from a calendar-like interface.
struct DateView: View {
    @Environment(\.dismiss) private var dismiss // Environment variable for dismissing the view.
    @StateObject private var viewModel = DateViewModel() // ViewModel to manage date-related logic.

    /// Callback to pass the selected date back to the parent view.
    var onDateSelected: (String) -> Void

    /// A computed property to display the current month and year in the header.
    private var displayedMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: viewModel.currentMonth)
    }

    var body: some View {
        VStack(spacing: 16) {
            // MARK: Header Section
            HStack {
                Text("Select a Date")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(Constants.Design.primaryColor)

                Spacer()

                // Close Button
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Constants.Design.primaryColor)
                        .padding()
                }
            }
            .padding(.horizontal)

            // MARK: Calendar Section
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    // Month Selector
                    HStack {
                        // Navigate to the previous month
                        Button(action: viewModel.goToPreviousMonth) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Constants.Design.primaryColor)
                        }

                        Spacer()

                        // Display the current month and year
                        Text(displayedMonth)
                            .font(.custom("Poppins-SemiBold", size: 18))
                            .foregroundColor(Constants.Design.secondaryColor)

                        Spacer()

                        // Navigate to the next month
                        Button(action: viewModel.goToNextMonth) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Constants.Design.primaryColor)
                        }
                    }
                    .padding(.horizontal)

                    // Calendar Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                        // Days of the week labels
                        ForEach(["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"], id: \.self) { day in
                            Text(day)
                                .font(.custom("Poppins-Regular", size: 12))
                                .foregroundColor(Constants.Design.primaryColor)
                                .frame(maxWidth: .infinity)
                        }

                        // Days in the selected month
                        ForEach(viewModel.generateDaysForMonth(), id: \.self) { date in
                            if let date = date {
                                Text("\(Calendar.current.component(.day, from: date))") // Display day number.
                                    .font(.custom("Poppins-Regular", size: 14))
                                    .foregroundColor(
                                        viewModel.isSelected(date) ? .white : (viewModel.isToday(date) ? .red : Constants.Design.primaryColor)
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(viewModel.isSelected(date) ? Constants.Design.secondaryColor : .clear)
                                    )
                                    .onTapGesture {
                                        viewModel.handleDateSelection(date) // Handle date selection on tap.
                                    }
                            } else {
                                Spacer() // Empty spaces for days not in the current month.
                            }
                        }
                    }
                }
            }

            // MARK: "Select Date" Button
            Button(action: {
                if let formattedDate = viewModel.getFormattedSelectedDate() {
                    onDateSelected(formattedDate) // Pass the selected date back via the callback.
                }
                dismiss() // Dismiss the view.
            }) {
                Text("Select Date")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Constants.Design.secondaryColor)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(.systemGroupedBackground).ignoresSafeArea()) // Background color to match grouped settings.
    }
}
