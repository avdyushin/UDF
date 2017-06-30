import Foundation

public protocol Action {
    func invoke(dispatcher: Dispatcher)
}
