//
//  JetDevsService.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 15/12/22.
//

import Alamofire
import PromisedFuture

// swiftlint: disable missing_brackets_unwrap extra_whitespace comments_capitalized_ignore_possible_code empty_first_line
class JetDevsService {
    @discardableResult
    func performRequest<T, U>(route: APIConfiguration,
                              decoder: JSONDecoder = JSONDecoder(),
                              errorType: U.Type) -> Future<T, Error> where T: Decodable, U: JetDevsError {
        return Future(operation: { completion in
            let isReachable = ReachabilityHandler.shared?.currentConnection.isReachable ?? false
            guard isReachable else {
                let error = GTEPError(message: MessageString.networkError, type: MessageString.oops)
                return completion(.failure(error))
            }
            AF.request(route)
                .validate()
                .responseDecodable(decoder: decoder, completionHandler: { (response: DataResponse<T, AFError>) in
                    switch response.result {
                    case .success(let value):
                        print("Response success: \(value)")
                        completion(.success(value))
                    case .failure(let error):
                        let backendError: U? = self.decodeError(from: response)
                        completion(.failure(backendError ?? error))
                    }
                })
        })
    }

    /// Play (GTEP) makes no distinction between a 200 and 204 status code.
    /// Prefer performRequest<T, U> whenever possible.
    /// Use this only if expected response is a Play Ok() with status code 200.
    /// AF adopts the  to the following HTTP Rules:
    /// https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.2.5
    func performRequestWithOKResponse<U>(route: APIConfiguration,
                                         decoder: JSONDecoder = JSONDecoder(),
                                         errorType: U.Type) -> Future<Data?, Error> where U: JetDevsError {
        return Future(operation: { completion in
            let isReachable = ReachabilityHandler.shared?.currentConnection.isReachable ?? false
            guard isReachable else {
                let error = GTEPError(message: MessageString.networkError, type: MessageString.oops)
                return completion(.failure(error))
            }

            Session.default.sessionConfiguration.timeoutIntervalForRequest = 0.1
            Session.default.sessionConfiguration.timeoutIntervalForResource = 0.1

            AF.request(route)
                .validate()
                .response { response in
                    switch response.result {
                    case .success(let result):
                        print("Response success: \(String(describing: result))")
                        completion(.success(result))
                    case .failure(let error):
                        let backendError: U? = self.decodeError(from: response)
                        completion(.failure(backendError ?? error))
                    }
                }
        })
    }

    func decodeError<T, U>(from response: AFDataResponse<T>) -> U? where U: JetDevsError {
        print("Error: \(response)")
        if let data = response.data {
            print("Error Response: \(String(describing: String(data: data, encoding: .utf8)))")
            if var customError = try? JSONDecoder().decode(U.self, from: data) {
                customError.code = response.response?.statusCode
                print("Error Response \(U.self): \(customError))")
                return customError
            }
        }
        return nil
    }
}
