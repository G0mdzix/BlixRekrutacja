extension AppError {
    /// Retrying cannot help: the quota resets monthly and a missing key needs a rebuild.
    var stopsLoading: Bool {
        self == .quotaExceeded || self == .missingAPIKey
    }
}
