import Combine
import Domain
import Foundation
import Observation

/// "Catalog" screen logic (MVVM).
///
/// The search uses Combine (on purpose, as a learning example).
/// The rest of the app uses `async/await` and `.task(id:)` for the same job (see `AddEntryView`),
/// so you can compare both ways side by side.
@MainActor
@Observable
public final class CatalogViewModel {
    public struct Output {
        public var drinkTapped: (Drink) -> Void
        public var addCustomTapped: () -> Void
        public init(drinkTapped: @escaping (Drink) -> Void, addCustomTapped: @escaping () -> Void) {
            self.drinkTapped = drinkTapped
            self.addCustomTapped = addCustomTapped
        }
    }

    public enum Filter: Hashable, CaseIterable { case all, mine }

    /// The search text. `.searchable` writes here on every key press.
    /// `didSet` pushes each new value into the Combine pipeline (see `init`).
    var query = "" {
        didSet { queries.send(query) }
    }
    var filter: Filter = .all
    private(set) var drinks: [Drink] = []

    @ObservationIgnored private let repository: any DrinkRepository
    @ObservationIgnored private let output: Output

    /// A "subject" is a publisher you can push values into by hand with `send(_:)`.
    /// `PassthroughSubject` keeps no current value (unlike `CurrentValueSubject`):
    /// it only passes new values on to whoever is subscribed right now.
    /// `Never` means this stream can never fail.
    @ObservationIgnored private let queries = PassthroughSubject<String, Never>()

    /// The subscription. Combine keeps the pipeline alive only while this object lives:
    /// when the view model is freed, `AnyCancellable` is freed too and cancels the pipeline.
    /// This is why the `sink` result must be stored. If you drop it, nothing ever arrives.
    @ObservationIgnored private var subscription: AnyCancellable?

    /// The search that is running now. A newer query cancels it, so an old,
    /// slow result can never replace a newer one.
    @ObservationIgnored private var searchTask: Task<Void, Never>?

    /// - Parameter debounce: how long to wait after the last key press.
    ///   Tests pass a short value so they run fast.
    public init(
        repository: any DrinkRepository,
        output: Output,
        debounce: DispatchQueue.SchedulerTimeType.Stride = .milliseconds(300)
    ) {
        self.repository = repository
        self.output = output

        // The Combine pipeline. Read it top to bottom, like a chain of filters:
        subscription =
            queries
            // 1. Drop spaces at the ends: "monster " and "monster" are the same search.
            .map { $0.trimmingCharacters(in: .whitespaces) }
            // 2. Wait until the user stops typing for `debounce`. Every new value restarts the timer,
            //    so typing "monster" quickly gives one search, not seven.
            //    `scheduler: DispatchQueue.main` = the timer runs on the main queue,
            //    so the value below also arrives on the main thread.
            .debounce(for: debounce, scheduler: DispatchQueue.main)
            // 3. Skip a value equal to the previous one ("mon" -> "mo" -> "mon" in one pause = no new search).
            .removeDuplicates()
            // 4. `sink` is the end of the pipeline: it runs our closure for each value
            //    and returns the `AnyCancellable` we keep above.
            .sink { [weak self] query in
                // The closure is not marked `@MainActor`, so Swift 6 does not know it runs on main.
                // We know it does (step 2 uses `DispatchQueue.main`), and `assumeIsolated` says so.
                // If this ever ran on another thread, the app would stop here in debug, not race.
                MainActor.assumeIsolated {
                    self?.search(query)
                }
            }
    }

    /// The bridge from Combine to async/await: start a `Task` for the async repository call.
    /// Cancel the previous one first (step "only the newest result wins").
    private func search(_ query: String) {
        searchTask?.cancel()
        searchTask = Task {
            guard let found = try? await repository.search(query), !Task.isCancelled else { return }
            drinks = found
        }
    }

    /// What the grid shows: search results, then the "All / Mine" filter.
    var visible: [Drink] {
        switch filter {
        case .all: drinks
        case .mine: drinks.filter(\.isCustom)
        }
    }

    /// The first load when the screen appears, and a reload after a custom drink was added
    /// (that is why it is public: the coordinator calls it). Uses the current `query` directly,
    /// without the debounce: here we want the result now.
    public func load() async {
        drinks = (try? await repository.search(query)) ?? []
    }

    func drinkTapped(_ drink: Drink) { output.drinkTapped(drink) }
    func addCustomTapped() { output.addCustomTapped() }
}
