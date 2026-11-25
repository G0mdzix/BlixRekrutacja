import Foundation

// MARK: - Info.plist
extension Bundle {
    var appVersion: String? { object(forInfoDictionaryKey: InfoPlistKey.appVersion) as? String }
    var buildNumber: String? { object(forInfoDictionaryKey: InfoPlistKey.buildNumber) as? String }
}

// MARK: - Constants

private enum InfoPlistKey {
    static let appVersion = "CFBundleShortVersionString"
    static let buildNumber = "CFBundleVersion"
}
