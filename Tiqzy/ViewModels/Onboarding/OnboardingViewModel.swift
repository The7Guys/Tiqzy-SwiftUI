import Foundation
import SwiftUI

/// ViewModel for managing the onboarding flow, including slide data and state transitions.
class OnboardingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentPage = 0               // Tracks the current slide index.
    @Published var isOnboardingComplete = false  // Indicates if onboarding is complete.
    @Published var showPreferencesView = false   // Indicates transition to the PreferencesView.
    @Published var showContentView = false       // Indicates transition to the ContentView.

    // MARK: - Onboarding Slides
    let slides = [
        OnboardingSlide(
            imageName: "bigPerson1",
            title: "Plan Your Perfect Trip",
            description: "Create unforgettable experiences with personalized recommendations and flexible options."
        ),
        OnboardingSlide(
            imageName: "bigPerson2",
            title: "Book and Access Tickets Easily",
            description: "Effortlessly book activities and keep all your tickets in one place, simple and stress-free!"
        ),
        OnboardingSlide(
            imageName: "bigPerson3",
            title: "Explore Unique Destinations",
            description: "Discover hidden gems and iconic landmarks tailored to your interests and preferences."
        )
    ]

    // MARK: - Public Methods
    /// Advances to the next slide or marks onboarding as complete.
    func nextPage() {
        if currentPage < slides.count - 1 {
            currentPage += 1
        } else {
            completeOnboarding()
        }
    }

    /// Checks if the user has seen onboarding and updates the state accordingly.
    func checkIfOnboardingSeen() {
        if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
            showContentView = true
        }
    }

    /// Marks onboarding as complete and saves the state to UserDefaults.
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        isOnboardingComplete = true
        showPreferencesView = true
    }

    /// Completes preferences and transitions to the main ContentView.
    func completePreferences() {
        showPreferencesView = false
        showContentView = true
    }
}
