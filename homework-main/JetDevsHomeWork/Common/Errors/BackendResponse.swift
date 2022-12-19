//
//  BackendResponse.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 15/12/22.
//

import Foundation

// swiftlint: disable invalid_mark_format empty_first_line orphaned_doc_comment superfluous_disable_command

/// Type to be used for all enums that represent an error from Backend

protocol JetDevsError: Error & LocalizedError & Decodable {
    var code: Int? { get set }
}

/// Structure for a custom JetDevs backend response.
struct BackendResponse<T> where T: JetDevsError {
    let message: T?
    let gtepError: GTEPError?
    let type: String?
    var code: Int?
}

// MARK: - JetDevsError
extension BackendResponse: JetDevsError {

    // MARK: LocalizedError

    /// Gets the localized description for a message or whatever message was sent from GTEP
    var errorDescription: String? {
        if let message = message {
            return message.localizedDescription
        } else if let gtepMessage = gtepError?.message, !gtepMessage.isEmpty {
            return gtepMessage
        } else {
            return MessageString.somethingWentWrong
        }
    }

    // MARK: Decodable

    enum CodingKeys: CodingKey {
        case message
        case type
    }

    /// Custom implementation for decoder to support T and custom errors from GTEP.
    ///
    /// - Parameter decoder: a decoder.
    /// - Throws: When a container does not contain one of the CodingKeys.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let message = try? container.decode(T.self, forKey: .message)
        let customMessage = try? container.decode(String.self, forKey: .message)    // Response will come as "message"
        let type = try? container.decode(String.self, forKey: .type)
        let gtepError = GTEPError(message: customMessage, type: type)
        self = .init(message: message, gtepError: gtepError, type: type)
    }
}

/// General structure for a GTEP Error.
struct GTEPError: JetDevsError {
    let message: String?
    let type: String?
    let exception: ServerExceptions?
    var code: Int?

    var errorDescription: String? {
        self.message
    }

    init(message: String?, type: String?) {
        self.message = message
        self.type = type
        if let type = type {
            self.exception = ServerExceptions(rawValue: type)
        } else {
            self.exception = nil
        }
    }
}

/// Exceptions thrown by Server
enum ServerExceptions: String, Decodable {
    case notAuthorizedException = "NotAuthorizedException"
}
