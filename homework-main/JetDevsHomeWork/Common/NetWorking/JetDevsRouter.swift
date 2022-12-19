//
//  JetDevsRouter.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 15/12/22.
//

import Alamofire
import Foundation

// swiftlint: disable conditional_returns_on_newline
enum JetDevsRouter: APIConfiguration {
    
    // MARK: - Routes
    case login(Encodable)
    
    // MARK: - BaseURL

    var baseUrl: String {
        switch self {
        default:
            return "https://jetdevs.mocklab.io/"
        }
    }

    var token: String? {
            return nil
    }

    // MARK: - HTTPMethod

    internal var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }

    // MARK: - Path

    internal var path: String {
        switch self {
        case .login:
            return "login"
        }
    }

    // MARK: - Parameters

    internal var parameters: Parameters? {
        switch self {
        case .login(let para):
            return para.asDictionary
        }
    }

    internal var customHeader: [String: Any]? {
            return nil
    }

    // MARK: - customParameters

    internal var customParameters: (contentType: String?, data: Data?)? {
        switch self {
        case let .login(params):
            let json = params.asJSONString
            print("Custom Parameters: \(String(describing: json))")
            return (ContentType.formUrlEncoded, json?.data(using: .utf8))
        }
    }

    // MARK: - ContentTypes

    var additionalContentTypes: [String] {
        switch self {
        default:
            return []
        }
    }
}

extension Encodable {

    /// Flat maps a JSON from an encodable object to create a dictionary
    var asDictionary: [String: Any] {
        guard
            let data = try? JSONEncoder().encode(self),
            let dict = (try? JSONSerialization.jsonObject(with: data,
                                                          options: .allowFragments)).flatMap({ $0 as? [String: Any] })
        else {
            return [:]
        }
        return dict
    }

    var asJSONString: String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    var asPrettyJsonString: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: asDictionary, options: .prettyPrinted) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
