import UIKit

@MainActor
final class SystemClipboard: Clipboard {
    func copy(_ text: String) {
        UIPasteboard.general.string = text
    }
}
