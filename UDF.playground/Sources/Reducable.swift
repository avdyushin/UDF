import Foundation

public protocol Reducable {
    associatedtype ActionType
    associatedtype StateType
    func reduce(action: ActionType, state: StateType) -> StateType
}
