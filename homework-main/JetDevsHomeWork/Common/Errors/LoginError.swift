//
//  LoginError.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 15/12/22.
//

import Foundation
// swiftlint: disable empty_first_line missing_brackets_unwrap identifier_name
struct LoginError: JetDevsError {

    var code: Int?
    var result: Int?
    let error: String?
    let error_message: String?
    let message: String?

    var errorDescription: String? { self.error_message ?? self.error }
 }
