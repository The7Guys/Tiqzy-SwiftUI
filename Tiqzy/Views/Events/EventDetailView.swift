import SwiftUI
import SwiftData
import FirebaseAuth
import FirebaseFirestore

struct EventDetailView: View {
    @StateObject private var viewModel: EventDetailViewModel
    let eventID: Int // Passed from the list view or navigation
    @State private var showMapDialog = false // State for showing the dialog
    @Environment(\.dismiss) private var dismiss // Environment dismiss action
    @State private var showShareSheet = false // State for triggering share sheet
    @Environment(\.modelContext) private var modelContext // Access Swift Data context
    @State private var isFavorite: Bool = false // Tracks if the event is a favorite
    private let db = Firestore.firestore() // Firestore instance
    
    init(eventID: Int) {
        self.eventID = eventID
        _viewModel = StateObject(wrappedValue: EventDetailViewModel(eventID: eventID))
    }
    
    var body: some View {
        ZStack {
            // Main Content
            if viewModel.isLoading {
                // Display a full-screen loading indicator while data is loading
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5) // Make it larger for emphasis
                    Text("Loading event details...")
                        .font(.custom("Poppins-Medium", size: 18))
                        .foregroundColor(Constants.Design.primaryColor)
                        .padding(.top, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground)) // Matches app background
                .ignoresSafeArea()
            } else {
                // Show actual content once loading is complete
                ScrollView {
                    VStack(spacing: 16) {
                        ZStack {
                            // Event Image
                            AsyncImage(url: URL(string: viewModel.event?.imageURL ?? "")) { phase in
                                if let image = phase.image {
                                    // Successfully loaded image
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width - 32, height: 400)
                                        .clipped()
                                        .cornerRadius(12)
                                        .transition(.opacity) // Smooth transition
                                } else if phase.error != nil {
                                    // Error loading image, show fallback
                                    Image("EventImage")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width - 32, height: 400)
                                        .clipped()
                                        .cornerRadius(12)
                                } else {
                                    // Placeholder while loading
                                    ZStack {
                                        Color.gray.opacity(0.2) // Placeholder background
                                            .frame(width: UIScreen.main.bounds.width - 32, height: 400)
                                            .cornerRadius(12)
                                        
                                        ProgressView() // Loading spinner
                                            .scaleEffect(1.5) // Adjust size of spinner
                                    }
                                }
                            }
                            
                            // Top-right "X" Button
                            VStack {
                                HStack {
                                    Spacer()
                                    Button(action: { dismiss() }) {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 12, height: 12)
                                            .padding()
                                            .background(Circle().fill(Color.black))
                                    }
                                    .padding(16)
                                }
                                Spacer()
                            }
                            
                            // Bottom-right action buttons
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    HStack(spacing: 16) {
                                        Button(action: toggleFavorite) {
                                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                                .foregroundColor(isFavorite ? .red : .white)
                                                .font(.title2)
                                                .padding(10)
                                                .background(Circle().fill(Color.black))
                                        }
                                        .onAppear {
                                            isFavorite = isEventFavorite(eventID)
                                        }
                                        
                                        Button(action: { showMapDialog = true }) {
                                            Image(systemName: "map")
                                                .font(.title2)
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(Circle().fill(Color.black))
                                        }
                                        
                                        Button(action: { showShareSheet = true }) {
                                            Image(systemName: "square.and.arrow.up")
                                                .font(.title2)
                                                .offset(y: -2)
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(Circle().fill(Color.black))
                                        }
                                    }
                                    .padding(16)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Event Title
                        Text(viewModel.event?.title ?? "Loading...")
                            .font(.custom("Poppins-Regular", size: 28))
                            .foregroundColor(Constants.Design.primaryColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        // Price Section
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(Constants.Design.primaryColor)
                            Text(viewModel.event?.location ?? "")
                                .font(.custom("Poppins-Regular", size: 18))
                                .foregroundColor(Constants.Design.primaryColor)
                            Spacer()
                            Text("from")
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(Constants.Design.primaryColor)
                                .offset(y: 5)
                            Text(
                                viewModel.event != nil ? "\(String(format: "%.2f€", viewModel.event!.price!))" : ""
                            )
                            .font(.custom("Poppins-Regular", size: 28))
                            .foregroundColor(Constants.Design.primaryColor)
                        }
                        .padding(.horizontal)
                        
                        // Buy Ticket Button
                        Button(action: saveTicket) {
                            Text("Buy Ticket")
                                .font(.custom("Poppins-Medium", size: 24))
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(Constants.Design.secondaryColor)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        // Event Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text(viewModel.event?.summary ?? "")
                                .font(.custom("Poppins-Regular", size: 16))
                                .foregroundColor(Constants.Design.primaryColor)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .confirmationDialog("Open Maps?", isPresented: $showMapDialog, titleVisibility: .visible) {
            Button("Open in Apple Maps") {
                if let url = viewModel.appleMapsURL() {
                    UIApplication.shared.open(url)
                }
            }
            Button("Open in Google Maps") {
                if let url = viewModel.googleMapsURL() {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: viewModel.generateShareContent())
        }
        .onAppear {
            viewModel.loadEventDetails()
        }
        .navigationBarHidden(true)
    }
    
    private func saveTicket() {
        guard let event = viewModel.event else { return }
        
        // Generate a unique ID for the ticket
        let ticketID = UUID().uuidString
        
        // Prepare ticket data for Firebase
        let ticketData: [String: Any] = [
            "id": ticketID,
            "userId": Auth.auth().currentUser?.uid ?? "unknown_user",
            "name": event.title,
            "imageURL": event.imageURL ?? "",
            "location": event.venueAddress ?? "",
            "date": event.startDate,
            "timeframe": "\(event.startDate) - \(event.endDate)"
        ]
        
        // Use the TicketService to save the ticket
        let ticketService = TicketService()
        ticketService.addTicket(Ticket(from: ticketData)) { error in
            if let error = error {
                print("Error saving ticket: \(error.localizedDescription)")
            } else {
                print("Ticket saved successfully!")
                
                // Increment the ticket count
                DispatchQueue.main.async {
                    AppState.shared.newTicketCount += 1
                }
            }
        }
    }

    /// Manages the favorite state of the event.
    private func toggleFavorite() {
        guard let event = viewModel.event else { return }

        if isFavorite {
            removeFavorite(eventID: event.id)
        } else {
            addFavorite(event)
        }
        isFavorite = isEventFavorite(event.id) // Synchronize state with the model
    }

    /// Marks the event as favorite and saves it.
    private func addFavorite(_ event: Event) {
        // Check if the event is already in favorites
        if !isEventFavorite(event.id) {
            let favoriteEvent = Event(
                id: event.id,
                title: event.title,
                summary: event.summary,
                startDate: event.startDate,
                endDate: event.endDate,
                venueAddress: event.venueAddress,
                location: event.location,
                duration: event.duration,
                imageURL: event.imageURL,
                price: event.price,
                stock: event.stock,
                category: event.category,
                isFavorite: true // Ensure this reflects the favorite state
            )
            modelContext.insert(favoriteEvent)
            try? modelContext.save() // Persist the new favorite
        }
    }

    /// Unmarks the event as favorite and removes it from the context.
    private func removeFavorite(eventID: Int) {
        // Fetch and delete the favorite event
        if let favorite = fetchEvent(by: eventID) {
            modelContext.delete(favorite) // Remove the event
            try? modelContext.save() // Persist changes
        }
    }

    /// Checks if the event is already a favorite.
    private func isEventFavorite(_ id: Int) -> Bool {
        fetchEvent(by: id) != nil
    }

    /// Fetches the event from the container by ID.
    private func fetchEvent(by id: Int) -> Event? {
        // Create a FetchDescriptor to filter by event ID
        let descriptor = FetchDescriptor<Event>(
            predicate: #Predicate { $0.id == id }
        )
        return try? modelContext.fetch(descriptor).first
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    EventDetailView(eventID: 1762)
}
