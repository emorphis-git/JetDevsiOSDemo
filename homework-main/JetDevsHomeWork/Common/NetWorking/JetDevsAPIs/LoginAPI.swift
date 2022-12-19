//
//  LoginAPI.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 15/12/22.
//

import PromisedFuture

protocol LoginAPI {

   func login(params: LoginParam) -> Future<LoginModel?, Error>

}
