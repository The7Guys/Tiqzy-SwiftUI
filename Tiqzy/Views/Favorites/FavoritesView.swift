import SwiftUI
import SwiftData

/// A view displaying the user's favorite events. If no favorites exist, a placeholder message is shown.
struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext // Access the SwiftData context for data operations.
    @Query var favorites: [Event] // Query to fetch favorite events from the SwiftData context.

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // MARK: - Title Section
                Text("Your Favorite Events")
                    .font(.custom("Poppins-SemiBold", size: 28))
                    .foregroundColor(Constants.Design.primaryColor)
                    .padding(.horizontal) // Add horizontal padding.
                    .padding(.top) // Add top padding.

                // MARK: - Content Section
                if favorites.isEmpty {
                    // Display a message and placeholder image when there are no favorite events.
                    VStack(spacing: 20) {
                        Image("EmptyFavorites") // Placeholder image for empty state.
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding(.top, 40) // Space from the title.

                        Text("No favorite events yet!")
                            .font(.custom("Poppins-SemiBold", size: 20))
                            .foregroundColor(Constants.Design.primaryColor)
                            .multilineTextAlignment(.center)

                        Text("Start exploring and add events to your favorites to see them here.")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40) // Horizontal padding for better alignment.
                    }
                    .frame(maxHeight: .infinity, alignment: .top) // Align content closer to the top of the screen.
                } else {
                    // MARK: - Favorite Events Section
                    // Display a scrollable list of favorite events.
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(favorites) { favorite in
                                NavigationLink(destination: EventDetailView(eventID: favorite.id)) {
                                    EventCard(event: favorite) // Use the EventCard to display each favorite event.
                                }
                                .buttonStyle(PlainButtonStyle()) // Removes default button style for a cleaner look.
                            }
                        }
                        .padding(.horizontal) // Add horizontal padding around the list.
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline) // Set the title display mode to inline.
            .background(Color(.systemGroupedBackground).ignoresSafeArea()) // Set background color.
        }
    }
}
