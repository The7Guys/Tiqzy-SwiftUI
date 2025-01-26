import SwiftUI

/// The onboarding screen guiding the user through slides and transitions to PreferencesView or ContentView.
struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel() // ViewModel handling onboarding logic.

    var body: some View {
        ZStack {
            // MARK: - Onboarding Slides
            if !viewModel.showPreferencesView && !viewModel.showContentView {
                VStack(spacing: 20) {
                    // TabView for onboarding slides
                    TabView(selection: $viewModel.currentPage) {
                        ForEach(0..<viewModel.slides.count, id: \.self) { index in
                            VStack {
                                Spacer()

                                Image(viewModel.slides[index].imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 300)

                                Text(viewModel.slides[index].title)
                                    .font(.custom("Poppins-SemiBold", size: 30))
                                    .foregroundColor(Constants.Design.primaryColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)

                                Text(viewModel.slides[index].description)
                                    .font(.custom("Poppins-Regular", size: 16))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)

                                Spacer()
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut, value: viewModel.currentPage)

                    // Next/Get Started Button
                    Button(action: viewModel.nextPage) {
                        Text(viewModel.currentPage == viewModel.slides.count - 1 ? "Get Started" : "Next")
                            .font(.custom("Poppins-Medium", size: 22))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Design.secondaryColor)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }

                    // Page Indicators
                    HStack {
                        ForEach(0..<viewModel.slides.count, id: \.self) { index in
                            Circle()
                                .fill(index == viewModel.currentPage ? Constants.Design.secondaryColor : Color.gray.opacity(0.5))
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding(.bottom, 16)
                }
                .transition(.opacity)
            }

            // MARK: - Preferences View
            if viewModel.showPreferencesView && !viewModel.showContentView {
                PreferencesView(onComplete: {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        viewModel.completePreferences()
                    }
                })
                .transition(.opacity)
            }

            // MARK: - ContentView
            if viewModel.showContentView {
                ContentView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            viewModel.checkIfOnboardingSeen()
        }
    }
}
