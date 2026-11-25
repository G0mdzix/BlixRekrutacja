@MainActor
protocol Clipboard: AnyObject {
    func copy(_ text: String)
}
