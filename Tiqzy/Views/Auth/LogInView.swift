import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 20) {
            // Title
            VStack(spacing: 8) {
                Text("Log in")
                    .font(.custom("Poppins-SemiBold", size: 30))
                    .foregroundColor(Constants.Design.primaryColor)
                
                Text("Log in and start exploring Holland")
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(.gray)
            }
            
            Spacer().frame(height: 20)
            
            // Email Field
            VStack(alignment: .leading, spacing: 12) {
                Text("Email")
                    .font(.custom("Poppins-Regular", size: 20))
                    .foregroundColor(Constants.Design.secondaryColor)
                
                TextField("e.g christianBale.com", text: $viewModel.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal)
            
            // Password Field
            VStack(alignment: .leading, spacing: 12) {
                Text("Password")
                    .font(.custom("Poppins-Regular", size: 20))
                    .foregroundColor(Constants.Design.secondaryColor)
                
                SecureField("••••••••", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            // Log In Button
            Button(action: {
                viewModel.logIn()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Constants.Design.secondaryColor)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                } else {
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
            .disabled(viewModel.isLoading)
            
            
            // Divider
            HStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 1)
                
                Text("Or")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.gray)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 1)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            // Apple and Google Login Buttons
            VStack(spacing: 20) {
                Button(action: {
                    viewModel.logInWithApple()
                }) {
                    HStack {
                        Image(systemName: "applelogo")
                        Text("Log in with Apple")
                            .font(.custom("Poppins-Regular", size: 16))
                    }
                    .foregroundColor(Constants.Design.primaryColor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Constants.Design.primaryColor))
                }
                
                Button(action: {
                    viewModel.logInWithGoogle()
                }) {
                    HStack {
                        Image("googleIcon") // Replace with Google logo
                        Text("Log in with Google")
                            .font(.custom("Poppins-Regular", size: 16))
                    }
                    .foregroundColor(Constants.Design.primaryColor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Constants.Design.primaryColor))
                }
            }
            .padding(.horizontal)
            
            Spacer()
            // Sign Up Text
            HStack {
                Text("Don’t have an account?")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.gray)
                
                Button(action: {
                    // Navigate to Sign Up
                }) {
                    Text("Sign Up")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(Constants.Design.secondaryColor)
                }
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
