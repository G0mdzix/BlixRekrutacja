import Foundation

// MARK: - Info.plist
extension Bundle {
    var appVersion: String? { object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String }
    var buildNumber: String? { object(forInfoDictionaryKey: "CFBundleVersion") as? String }
}
