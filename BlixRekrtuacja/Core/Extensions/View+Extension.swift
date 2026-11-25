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
            actions: { _ in Button(.commonOk, role: .cancel) {} },
            message: { Text($0.message) }
        )
    }
}
