//
//  APIConfiguration.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 15/12/22.
//

import Alamofire
import Foundation
// swiftlint: disable empty_first_line
protocol APIConfiguration: URLRequestConvertible {
    var baseUrl: String { get }
    var token: String? { get }
    var userCredentials: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var customParameters: (contentType: String?, data: Data?)? { get }
    var additionalContentTypes: [String] { get }
    var customHeader: [String: Any]? { get }
}

extension APIConfiguration {
    var userCredentials: String {
        return "Bearer \(token ?? "")"
    }

    // MARK: - URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseUrl + path)! // swiftlint:disable:this force_unwrapping
        var urlRequest = URLRequest(url: url)
        print("URL request (\(method.rawValue)): \(urlRequest)")

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Common Headers
        urlRequest.setValue(ContentType.json, forHTTPHeaderField: HTTPHeaderField.acceptType)
        additionalContentTypes.forEach {
            urlRequest.addValue($0, forHTTPHeaderField: HTTPHeaderField.acceptType)
        }

        if token != nil {
            print("Authorization: \(userCredentials)")
            urlRequest.setValue(userCredentials, forHTTPHeaderField: HTTPHeaderField.authorization)
        }

        customHeader?.forEach { key, value in
            let valueString = value as? String
            urlRequest.setValue(valueString, forHTTPHeaderField: key)
        }

        // Parameters
        if let customParameters = customParameters {
            urlRequest.setValue(customParameters.contentType, forHTTPHeaderField: HTTPHeaderField.contentType)
            urlRequest.httpBody = customParameters.data
        } else if let parameters = parameters {
            print("Parameters: \(parameters)")
            do {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }

        return urlRequest
    }
}
