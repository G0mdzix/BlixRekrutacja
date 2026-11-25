import Foundation

extension Bundle {
    var fixerAPIKey: String {
        object(forInfoDictionaryKey: FixerInfoKey.apiKey) as? String ?? ""
    }

    var fixerBaseURL: URL {
        guard
            let text = object(forInfoDictionaryKey: FixerInfoKey.baseURL) as? String,
            let url = URL(string: text)
        else {
            preconditionFailure("Info.plist has no valid \(FixerInfoKey.baseURL)")
        }
        return url
    }
}

// MARK: - Constants

private enum FixerInfoKey {
    static let apiKey = "FixerAPIKey"
    static let baseURL = "FixerBaseURL"
}
