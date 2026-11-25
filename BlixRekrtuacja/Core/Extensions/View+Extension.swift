import SwiftUI

// MARK: - Error alert
extension View {
    func errorAlert(_ error: AppError?, onDismiss: @escaping @MainActor () -> Void) -> some View {
        alert(
            .errorTitle,
            isPresented: Binding(
                get: { error != nil },
                set: { if !$0 { onDismiss() } }
            ),
            presenting: error,
            actions: { _ in },
            message: { Text($0.message) }
        )
    }
}

// MARK: - Typography
extension View {
    func typography(_ style: Typography) -> some View {
        font(style.font)
    }
}
