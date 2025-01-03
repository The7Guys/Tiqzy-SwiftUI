import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            VStack(spacing: 8) {
                Text("Sign Up")
                    .font(.custom("Poppins-SemiBold", size: 30))
                    .foregroundColor(Constants.Design.primaryColor)
                
                Text("Create an account to start exploring Holland")
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(.gray)
            }
            
            Spacer().frame(height: 20)
            
            // Name Field
            VStack(alignment: .leading, spacing: 12) {
                Text("Name")
                    .font(.custom("Poppins-Regular", size: 20))
                    .foregroundColor(Constants.Design.secondaryColor)
                
                TextField("e.g John Doe", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            // Email Field
            VStack(alignment: .leading, spacing: 12) {
                Text("Email")
                    .font(.custom("Poppins-Regular", size: 20))
                    .foregroundColor(Constants.Design.secondaryColor)
                
                TextField("e.g john.doe@gmail.com", text: $viewModel.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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
            
            // Sign Up Button
            Button(action: {
                viewModel.register()
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
            .disabled(viewModel.isLoading)
            
            Spacer()
            
            // Login Text
            HStack {
                Text("Already have an account?")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.gray)
                
                Button(action: {
                    // Navigate to Login
                }) {
                    Text("Log In")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(Constants.Design.secondaryColor)
                }
            }
        }
        .padding()
    }
}

#Preview {
    RegisterView()
}
