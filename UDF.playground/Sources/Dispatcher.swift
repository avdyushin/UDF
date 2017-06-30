import Foundation

public typealias DispatchToken = String

public protocol Dispatchable {
    func dispatch<T: Action>(action: T)
    func register<T: Action>(type: T.Type, handler: @escaping (T) -> Void) -> DispatchToken
    func unregister(dispatchToken: DispatchToken)
}

public struct DispatchHandler<T: Action> {
    let handler: (T) -> Void

    init(handler: @escaping (T) -> Void) {
        self.handler = handler
    }
}

public class Dispatcher: Dispatchable {

    fileprivate var listeners = [DispatchToken: AnyObject]()

    public static var `default` = Dispatcher()

    public func dispatch<T: Action>(action: T) {
        listeners.values
            .flatMap { $0 as? DispatchHandler<T> }
            .forEach { $0.handler(action) }
    }

    public func register<T: Action>(type: T.Type, handler: @escaping (T) -> Void) -> DispatchToken {
        let token = NSUUID().uuidString
        listeners[token] = DispatchHandler() { handler($0) } as AnyObject
        return token
    }

    public func unregister(dispatchToken: DispatchToken) {
        listeners.removeValue(forKey: dispatchToken)
    }
}
