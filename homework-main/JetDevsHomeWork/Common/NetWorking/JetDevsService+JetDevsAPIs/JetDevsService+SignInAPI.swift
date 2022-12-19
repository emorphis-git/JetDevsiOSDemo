//
//  JetDevsService+SignInAPI.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 15/12/22.
//

import Foundation
import PromisedFuture

// MARK: - JetDevsLoginAPI
extension JetDevsService: LoginAPI {

    func login(params: LoginParam) -> Future<LoginModel?, Error> {
        performRequest(route: JetDevsRouter.login(params), errorType: LoginError.self)
    }

}
