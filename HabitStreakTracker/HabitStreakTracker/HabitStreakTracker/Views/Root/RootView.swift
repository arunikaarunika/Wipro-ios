
import SwiftUI

struct RootView: View {
    @StateObject private var auth = AuthViewModel()
    @StateObject private var store = HabitStore()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            if auth.isUnlocked {
                MainTabView()
                    .environmentObject(store)
                    .transition(.opacity)
            } else {
                AuthView(viewModel: auth)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: auth.isUnlocked)
        .task {
            // Face ID prompt on app launch.
            await auth.authenticateWithBiometrics()
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                auth.lock()
            case .active:
                store.refresh()
                Task { await auth.handleBecameActive() }
            default:
                break
            }
        }
    }
}
