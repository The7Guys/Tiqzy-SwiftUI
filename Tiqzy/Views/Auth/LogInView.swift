import SwiftUI

/// A view for the user to log in with email and password.
struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel() // The view model handling login logic.
    @Environment(\.dismiss) private var dismiss // Environment variable to dismiss the login screen.

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // MARK: - Title Section
                VStack(spacing: 8) {
                    Text("Log in")
                        .font(.custom("Poppins-SemiBold", size: 30))
                        .foregroundColor(Constants.Design.primaryColor)

                    Text("Log in and start exploring Holland")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.gray)
                }

                Spacer().frame(height: 20)

                // MARK: - Email Input Field
                VStack(alignment: .leading, spacing: 12) {
                    Text("Email")
                        .font(.custom("Poppins-Regular", size: 20))
                        .foregroundColor(Constants.Design.secondaryColor)

                    TextField("e.g christianBale@gmail.com", text: $viewModel.email)
                        .autocapitalization(.none) // Prevents auto-capitalization for email.
                        .keyboardType(.emailAddress) // Uses the email keyboard layout.
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundStyle(.gray)
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

                // MARK: - Log In Button
                Button(action: {
                    viewModel.logIn { success in
                        if success {
                            dismiss() // Dismiss the LoginView on successful login.
                        }
                    }
                }) {
                    if viewModel.isLoading {
                        // Show a loading indicator while login is in progress.
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Design.secondaryColor)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                    } else {
                        // Default login button.
                        Text("Log In")
                            .font(.custom("Poppins-Medium", size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Design.secondaryColor)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }
                .disabled(viewModel.isLoading) // Disable the button when loading.

                // MARK: - Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.red) // Highlight the error in red.
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()

                // MARK: - Sign Up Navigation
                HStack {
                    Text("Don’t have an account?")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.gray)

                    NavigationLink(destination: RegisterView()) {
                        Text("Sign Up")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(Constants.Design.secondaryColor)
                    }
                }
            }
            .padding()
        }
    }
}
