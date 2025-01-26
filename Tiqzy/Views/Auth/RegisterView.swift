import SwiftUI

/// A view for user registration, allowing users to create an account.
struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel() // ViewModel handling registration logic.
    @State private var navigateToProfile = false // Tracks navigation to the ProfileView on successful registration.

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // MARK: - Title Section
                VStack(spacing: 8) {
                    Text("Sign Up")
                        .font(.custom("Poppins-SemiBold", size: 30))
                        .foregroundColor(Constants.Design.primaryColor)

                    Text("Create an account to start exploring Holland")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.gray)
                }

                Spacer().frame(height: 20)

                // MARK: - Name Input Field
                VStack(alignment: .leading, spacing: 12) {
                    Text("Name")
                        .font(.custom("Poppins-Regular", size: 20))
                        .foregroundColor(Constants.Design.secondaryColor)

                    TextField("e.g John Doe", text: $viewModel.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)

                // MARK: - Email Input Field
                VStack(alignment: .leading, spacing: 12) {
                    Text("Email")
                        .font(.custom("Poppins-Regular", size: 20))
                        .foregroundColor(Constants.Design.secondaryColor)

                    TextField("e.g john.doe@gmail.com", text: $viewModel.email)
                        .autocapitalization(.none) // Prevents automatic capitalization for email.
                        .keyboardType(.emailAddress) // Uses an email-optimized keyboard layout.
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)

                // MARK: - Password Input Field
                VStack(alignment: .leading, spacing: 12) {
                    Text("Password")
                        .font(.custom("Poppins-Regular", size: 20))
                        .foregroundColor(Constants.Design.secondaryColor)

                    SecureField("••••••••", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)

                // MARK: - Sign Up Button
                Button(action: {
                    viewModel.register() // Trigger the registration process.
                }) {
                    if viewModel.isLoading {
                        // Show a loading indicator while registration is in progress.
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Design.secondaryColor)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                    } else {
                        // Default "Sign Up" button.
                        Text("Sign Up")
                            .font(.custom("Poppins-Medium", size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Design.secondaryColor)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }
                .disabled(viewModel.isLoading) // Disable the button while loading.

                // MARK: - Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.red) // Highlight the error in red.
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // MARK: - Navigation on Successful Registration
                NavigationLink(
                    destination: ProfileView(), // Navigate to ProfileView after successful registration.
                    isActive: $viewModel.isRegistrationSuccessful
                ) {
                    EmptyView() // Invisible navigation link.
                }

                Spacer()

                // MARK: - Navigate to Login Screen
                HStack {
                    Text("Already have an account?")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.gray)

                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(Constants.Design.secondaryColor)
                    }
                }
            }
            .padding() // Adds padding around the content.
        }
    }
}
