/// Lets layers that depend on Core (e.g. Data) map their errors to `AppError` without Core knowing them.
protocol AppErrorConvertible: Error {
    /// `nil` for cancellation — there is nothing to show the user.
    var appError: AppError? { get }
}
