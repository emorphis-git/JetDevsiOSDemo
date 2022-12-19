//
//  ReachabilityHandler.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 15/12/22.
//

// swiftlint: disable empty_line_after_guard empty_first_line conditional_returns_on_newline
import Reachability

class ReachabilityHandler {

    // MARK: - Dependencies

    @Inject private var notificationCenter: NotificationCenter

    // MARK: - Singleton

    static let shared = ReachabilityHandler()

    // MARK: - Properties

    let reachability: Reachability

    private var lastConnectionType: ConnectionType

    var currentConnection: ConnectionType {
        return ConnectionType(from: reachability.connection)
    }

    // MARK: - Lifecycle

    private init?() {
        guard let unwrappedReachability = try? Reachability() else { return nil }
        reachability = unwrappedReachability
        lastConnectionType = ConnectionType(from: reachability.connection)
        guard (try? addReachabilityObserver()) != nil else { return nil }
    }

    deinit {
        removeReachabilityObserver()
    }
}

private extension ReachabilityHandler {
    func addReachabilityObserver() throws {
        reachability.whenReachable = { [weak self] reachability in
            self?.reachabilityChanged(to: reachability)
        }
        reachability.whenUnreachable = { [weak self] reachability in
            self?.reachabilityChanged(to: reachability)
        }
        try reachability.startNotifier()
    }

    func removeReachabilityObserver() {
        reachability.stopNotifier()
    }

    func reachabilityChanged(to reachability: Reachability) {
        let connectionType = ConnectionType(from: reachability.connection)

        // Avoid multiple notification
        guard connectionType != lastConnectionType else { return }
        lastConnectionType = connectionType

        // Notification to post system wide updates
        notificationCenter.post(name: NSNotification.Name(rawValue: "reachabilityDidChange"), object: connectionType)
    }
}
