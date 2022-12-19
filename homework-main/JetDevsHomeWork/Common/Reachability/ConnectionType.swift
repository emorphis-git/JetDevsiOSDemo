//
//  ConnectionType.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 15/12/22.
//

import CoreTelephony
import Reachability

// swiftlint: disable comments_capitalized_ignore_possible_code
enum ConnectionType: Equatable {
    case none
    case wifi
    case wwan2g
    case wwan3g
    case wwan4g
    case unknown(name: String)

    /// init to bridge from Reachability.Connection to ConnectionType
    ///
    /// - Parameter connection: Reachability.Connection
    init(from connection: Reachability.Connection) {
        switch connection {
        case .none, .unavailable:
            self = .none
        case .wifi:
            self = .wifi
        case .cellular:
            if #available(iOS 12.0, *) {
                self = ConnectionType.getServiceCurrentRadioAccessTechnology()
            } else {
                self = ConnectionType.getCurrentRadioAccessTechnology()
            }
        }
    }

    var isReachable: Bool {
        return self != .none
    }

    var description: String { "\(self)" }
}

// MARK: - Radio Access Technology
extension ConnectionType {
    
    @available(iOS 12.0, *)
    private static func getServiceCurrentRadioAccessTechnology() -> ConnectionType {
        return groupRadioConnection(
            CTTelephonyNetworkInfo()
                .serviceCurrentRadioAccessTechnology?
                .first?
                .value)
    }

    @available(iOS, introduced: 7.0, deprecated: 12.0, message: "Remove when dropping support for iOS 11")
    private static func getCurrentRadioAccessTechnology() -> ConnectionType {
        return groupRadioConnection(
            CTTelephonyNetworkInfo()
                .currentRadioAccessTechnology)
    }

    private static func groupRadioConnection(_ radioAccessTechnology: String?) -> ConnectionType {
        switch radioAccessTechnology {
        case CTRadioAccessTechnologyGPRS,
             CTRadioAccessTechnologyEdge,
             CTRadioAccessTechnologyCDMA1x:
            return .wwan2g
        case CTRadioAccessTechnologyWCDMA,
             CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyeHRPD:
            return .wwan3g
        case CTRadioAccessTechnologyLTE:
            return .wwan4g
        default:
            return .unknown(name: radioAccessTechnology ?? "No radio access")
        }
    }
}
