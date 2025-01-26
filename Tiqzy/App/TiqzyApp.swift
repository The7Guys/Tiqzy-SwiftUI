import SwiftUI
import SwiftData
import Firebase

/// The entry point of the Tiqzy app, responsible for initializing Firebase, managing splash screen,
/// onboarding flow, and setting up the main content view.
@main
struct TiqzyApp: App {
    /// Controls the visibility of the splash screen.
    @State private var showSplashScreen = true
    
    /// Controls the preloading of the `ContentView`.
    @State private var preloadContentView = false
    
    /// Controls whether the onboarding view is displayed.
    @State private var showOnboarding = false

    /// Initializes the app, configures Firebase, and determines if onboarding should be shown.
    init() {
        // Check if the user has already seen the onboarding flow.
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        _showOnboarding = State(initialValue: !hasSeenOnboarding)
        
        // Initialize Firebase
        FirebaseApp.configure()
        print("Firebase App Initialized")
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                // The main content view of the app.
                ContentView()
                    .opacity(preloadContentView && !showSplashScreen && !showOnboarding ? 1 : 0) // Show only after splash screen and onboarding
                    .onAppear {
                        preloadContentView = true // Preload `ContentView` in the background
                    }

                // Onboarding view, shown only if the user hasn't seen onboarding.
                if showOnboarding && !showSplashScreen {
                    OnboardingView()
                        .transition(.move(edge: .trailing)) // Smooth slide-in transition
                        .onDisappear {
                            // Mark onboarding as completed in UserDefaults
                            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        }
                }

                // Splash screen view, shown for a short duration on app launch.
                if showSplashScreen {
                    SplashScreenView()
                        .transition(.scale(scale: 1.2).combined(with: .opacity)) // Zoom-out and fade animation
                        .onAppear {
                            // Hide splash screen after a 2-second delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    showSplashScreen = false
                                }
                            }
                        }
                }
            }
            // Apply smooth animations for splash screen transitions
            .animation(.easeInOut(duration: 1.0), value: showSplashScreen)
        }
        // Add a model container for the `Event` entity used with SwiftData
        .modelContainer(for: [Event.self])
    }
}
