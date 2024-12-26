import SwiftUI

struct DateView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DateViewModel()

    var onDateSelected: (String) -> Void // Callback to pass the selected date(s)

    private var displayedMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: viewModel.currentMonth)
    }

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("Select Dates")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(Constants.Design.primaryColor)

                Spacer()

                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Constants.Design.primaryColor)
                        .padding()
                }
            }
            .padding(.horizontal)

            // Calendar Section
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    // Month Selector
                    HStack {
                        Button(action: viewModel.goToPreviousMonth) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Constants.Design.primaryColor)
                        }

                        Spacer()

                        Text(displayedMonth)
                            .font(.custom("Poppins-SemiBold", size: 18))
                            .foregroundColor(Constants.Design.secondaryColor)

                        Spacer()

                        Button(action: viewModel.goToNextMonth) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Constants.Design.primaryColor)
                        }
                    }
                    .padding(.horizontal)

                    // Calendar Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                        // Days of the week
                        ForEach(["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"], id: \.self) { day in
                            Text(day)
                                .font(.custom("Poppins-Regular", size: 12))
                                .foregroundColor(Constants.Design.primaryColor)
                                .frame(maxWidth: .infinity)
                        }

                        // Days in the month
                        ForEach(viewModel.generateDaysForMonth(), id: \.self) { date in
                            if let date = date {
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .font(.custom("Poppins-Regular", size: 14))
                                    .foregroundColor(viewModel.isToday(date) ? .red : Constants.Design.primaryColor)
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(viewModel.isSelected(date) ? Constants.Design.secondaryColor : .clear)
                                    )
                                    .onTapGesture {
                                        viewModel.handleDateSelection(date)
                                    }
                            } else {
                                Spacer()
                            }
                        }
                    }
                }
            }

            // "Select Dates" Button
            Button(action: {
                if let startDate = viewModel.selectedStartDate {
                    if let endDate = viewModel.selectedEndDate {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd MMM"
                        onDateSelected("\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))")
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd MMM yyyy"
                        onDateSelected(formatter.string(from: startDate))
                    }
                }
                dismiss()
            }) {
                Text("Select Dates")
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
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}
