import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Profile Header
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Constants.Design.primaryColor)

                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                            .font(.custom("Poppins-SemiBold", size: 34))
                            .foregroundColor(Constants.Design.primaryColor)
                    }

                    Spacer()
                }
                .padding(.horizontal)

                // Menu Items
                VStack(spacing: 16) {
                    ForEach(viewModel.menuItems, id: \.title) { item in
                        NavigationLink(value: item.destination) {
                            HStack {
                                Image(systemName: item.icon)
                                    .font(.title2)
                                    .foregroundColor(Constants.Design.primaryColor)

                                Text(item.title)
                                    .font(.custom("Poppins-Regular", size: 30))
                                    .foregroundColor(Constants.Design.primaryColor)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.title3)
                                    .foregroundColor(Constants.Design.primaryColor)
                            }
                            .padding()
                            .background(Constants.Design.primaryColor.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Log Out Button
                Text("Log out")
                    .font(.custom("Poppins-Regular", size: 22))
                    .foregroundColor(Constants.Design.primaryColor)
                    .padding(.bottom, 24)
            }
            .navigationBarHidden(true)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationDestination(for: Destination.self) { destination in
                destinationView(for: destination)
            }
        }
    }

    @ViewBuilder
    private func destinationView(for destination: Destination) -> some View {
        switch destination {
        case .favorites:
            FavoritesView()
        case .pastOrders:
            PastOrdersView()
        case .payment:
            PaymentView()
        case .settings:
            PreferencesView(
                onComplete: { print("Preferences completed")
                },
                showBottomButtons: false)
        case .help:
            HelpView()
        }
    }
}

#Preview {
    ProfileView()
}
