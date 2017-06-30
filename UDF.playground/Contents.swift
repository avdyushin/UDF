//: Playground - noun: a place where people can play

import UIKit

enum MyActions: Action {

    case get
    case set(String)

    func invoke(dispatcher: Dispatcher = .default) {
        dispatcher.dispatch(action: self)
    }

}

struct MyState: State {
    var string: String? = "Hello Store"
}

struct MyReducer: Reducable {
    typealias ActionType = MyActions
    typealias StateType = MyState
    func reduce(action: MyActions, state: MyState) -> MyState {
        var newState = state
        switch action {
        case .get:
            ()
        case .set(let string):
            newState.string = string
        }
        return newState
    }
}

class MyStore: Store {

    let dispatcher = Dispatcher.default
    let reducer = MyReducer()
    var state = MyState()
    var tokens = [DispatchToken]()

    override init() {
        super.init()
        let token = dispatcher.register(type: MyActions.self) { action in
            self.state = self.reducer.reduce(action: action, state: self.state)
            self.emitChange()
        }
        tokens.append(token)
    }

    deinit {
        for token in tokens {
            dispatcher.unregister(dispatchToken: token)
        }
        tokens.removeAll()
    }
}

let store = MyStore()

store.subscribe {
    print("dodo \(store.state.string ?? "empty")")
}

MyActions.get.invoke()
MyActions.set("LOL").invoke()
MyActions.get.invoke()
MyActions.set("Wowo").invoke()
MyActions.get.invoke()
