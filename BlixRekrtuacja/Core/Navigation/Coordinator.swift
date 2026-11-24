import Observation

@MainActor
protocol Coordinator: AnyObject, Observable {
    associatedtype Route: Hashable
    var path: [Route] { get set }
}

extension Coordinator {
    func push(_ route: Route) { path.append(route) }
    func pop() { _ = path.popLast() }
    func popToRoot() { path.removeAll() }
}
