import SwiftUI

@main
struct BlixRekrtuacjaApp: App {
    /// Not built when the app only hosts unit tests: no store is opened and no request can be sent.
    private let container = ProcessInfo.processInfo.isUnitTestHost ? nil : AppContainer()

    var body: some Scene {
        WindowGroup {
            if let container { RootView(container: container) }
        }
    }
}
