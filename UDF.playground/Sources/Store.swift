import Foundation

public typealias SubscriberToken = String
public typealias SubscriberHandler = () -> Void

public protocol Subscriber {
    var handler: SubscriberHandler { get set }
}

public protocol Subscrible {
    func subscribe(handler: @escaping SubscriberHandler) -> SubscriberToken
    func unsubscribe(key: SubscriberToken)
    func emitChange()
}

struct StoreSubscriber: Subscriber {
    var handler: SubscriberHandler
}

open class Store: Subscrible {

    fileprivate var subscribers = [SubscriberToken: Subscriber]()

    public init() { }
    
    public func subscribe(handler: @escaping SubscriberHandler) -> SubscriberToken {
        let token = NSUUID().uuidString
        subscribers[token] = StoreSubscriber( handler: handler)
        return token
    }

    public func unsubscribe(key: SubscriberToken) {
        subscribers.removeValue(forKey: key)
    }

    public func emitChange() {
        subscribers.values.forEach { $0.handler() }
    }

}
