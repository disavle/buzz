import Observation
import SwiftUI

// A tiny Redux, about 50 lines. This is how TCA works inside, without the magic.
//
//   View --send(Action)--> Store --> reduce(&State, Action) --> Effect
//    ^                       |                                    |
//    +------- state ---------+<---------- send(Action) -----------+
//
// 1. All screen state is one struct, `State`.
// 2. The only way to change it is to send an `Action`.
// 3. A pure function `reduce(&state, action)` changes the state and may return an `Effect`.
// 4. An `Effect` is async work (network, disk). When done, it sends new actions.
//
// More: docs/client/architecture-experiments.md, section 2.

/// Async work that a reducer asks the store to run.
public struct Effect<Action: Sendable>: Sendable {
    public typealias Send = @Sendable (Action) async -> Void
    let run: @Sendable (_ send: @escaping Send) async -> Void

    /// No work.
    public static var none: Self { Self { _ in } }

    /// Run some async code. Call `send` to deliver results back to the reducer.
    public static func run(_ work: @escaping @Sendable (_ send: @escaping Send) async -> Void) -> Self {
        Self(run: work)
    }
}

/// A reducer is just a function. Pure: no async, no side effects, only state changes.
public typealias Reducer<State, Action: Sendable> = (inout State, Action) -> Effect<Action>

/// Holds the state, runs the reducer and the effects.
/// `@Observable`: a view redraws only when the parts of `state` it reads change.
@MainActor
@Observable
public final class Store<State, Action: Sendable> {
    public private(set) var state: State
    @ObservationIgnored private let reducer: Reducer<State, Action>
    @ObservationIgnored private var tasks: [Task<Void, Never>] = []

    public init(initial: State, reducer: @escaping Reducer<State, Action>) {
        self.state = initial
        self.reducer = reducer
    }

    public func send(_ action: Action) {
        let effect = reducer(&state, action)
        let task = Task {
            // `weak self`: a long effect (like a status subscription) must not keep the store alive.
            await effect.run { [weak self] next in
                await self?.send(next)
            }
        }
        tasks.append(task)
    }

    /// Cancel long effects (like a subscription) when the screen goes away.
    public func cancelEffects() {
        tasks.forEach { $0.cancel() }
        tasks.removeAll()
    }

    /// A Binding for controls (Stepper, Toggle): read from `state`, write by sending an action.
    public func binding<Value>(_ keyPath: KeyPath<State, Value>, send action: @escaping (Value) -> Action) -> Binding<
        Value
    > {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.send(action($0)) }
        )
    }
}
