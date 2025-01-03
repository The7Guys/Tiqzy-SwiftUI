import SwiftUI

struct EventCard: View {
    let event: Event

    var body: some View {
        HStack(spacing: 0) { // Align image and details seamlessly
            // Event Image
            AsyncImage(url: URL(string: event.imageURL ?? "")) { phase in
                switch phase {
                case .empty:
                    // Placeholder while loading
                    Image("EventImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100)
                        .frame(maxHeight: .infinity)
                        .clipped()
                case .success(let image):
                    // Successfully loaded image
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100)
                        .frame(maxHeight: .infinity)
                        .clipped()
                case .failure:
                    // Failed to load, show placeholder
                    Image("EventImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100)
                        .frame(maxHeight: .infinity)
                        .clipped()
                @unknown default:
                    EmptyView()
                }
            }

            // Event Details
            VStack(alignment: .leading, spacing: 8) {
                // Event Title
                Text(event.title)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(Constants.Design.primaryColor)

                // Location
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundColor(Constants.Design.primaryColor)

                    Text(event.location ?? "Bunga")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(Constants.Design.primaryColor)
                }

                // Description
                Text(event.description)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(Constants.Design.primaryColor)
                    .lineLimit(2)

                // Duration and Price
                HStack {
                    // Time Icon and Duration
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundColor(Constants.Design.primaryColor)

                        Text(
                            formatDuration(event.duration)
                        ) // Use formatted duration
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(Constants.Design.primaryColor)
                    }

                    Spacer()

                    // Price
                    Text("from \(String(format: "€%.2f", event.price ?? "Free"))")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(Constants.Design.primaryColor)
                }
            }
            .padding()
            .background(Constants.Design.backgroundColor) // Use background color from constants
        }
        .overlay( // Border with primary color
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Design.primaryColor, lineWidth: 2)
        )
        .cornerRadius(12)
    }

    // Helper function to format the duration
    private func formatDuration(_ durationInMinutes: Int) -> String {
        if durationInMinutes < 60 {
            return "\(durationInMinutes) minutes"
        } else {
            let hours = durationInMinutes / 60
            let minutes = durationInMinutes % 60
            return minutes == 0 ? "\(hours) hours" : "\(hours)h \(minutes)m"
        }
    }
}

//http://localhost:3000/api/v1/tickets?start_date=2025-01-06&venueCity=Beverwijk
