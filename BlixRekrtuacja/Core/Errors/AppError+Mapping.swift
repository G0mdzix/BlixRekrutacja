import OSLog

extension AppError {
    init?(_ error: any Error) {
        switch error {
        case let appError as AppError:
            self = appError
        case let convertible as any AppErrorConvertible:
            guard let appError = convertible.appError else { return nil }
            self = appError
        case is CancellationError:
            return nil
        default:
            Logger.app.error("Unmapped error: \(String(describing: error), privacy: .public)")
            self = .unknown
        }
    }
}
