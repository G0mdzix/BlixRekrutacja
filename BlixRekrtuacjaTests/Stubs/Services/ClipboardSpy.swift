@testable import BlixRekrtuacja

@MainActor
final class ClipboardSpy: Clipboard {
    private(set) var copied: [String] = []

    func copy(_ text: String) { copied.append(text) }
}
