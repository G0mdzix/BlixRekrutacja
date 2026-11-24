import SwiftUI

struct CoordinatedStack<C: Coordinator, Root: View, Destination: View>: View {
    @Bindable var coordinator: C
    @ViewBuilder let root: () -> Root
    @ViewBuilder let destination: (C.Route) -> Destination

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            root().navigationDestination(for: C.Route.self, destination: destination)
        }
    }
}
