import SwiftUI

// MARK: - Error alert
extension View {
    func errorAlert(_ error: Binding<AppError?>) -> some View {
        alert(
            .errorTitle,
            isPresented: Binding(
                get: { error.wrappedValue != nil },
                set: { if !$0 { error.wrappedValue = nil } }
            ),
            presenting: error.wrappedValue,
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
