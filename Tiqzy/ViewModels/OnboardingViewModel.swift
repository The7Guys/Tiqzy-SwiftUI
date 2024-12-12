import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    @Published var isOnboardingComplete = false

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

    func nextPage() {
        if currentPage < slides.count - 1 {
            currentPage += 1
        } else {
            isOnboardingComplete = true
        }
    }
}
