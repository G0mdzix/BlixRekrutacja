@testable import BlixRekrtuacja
import Observation

@MainActor @Observable
final class CoordinatorStub: Coordinator {
    var path: [Int] = []
}
