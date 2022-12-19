//
//  LoginModel.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 14/12/22.
//

import Alamofire
import Foundation
import RxCocoa
import RxSwift
import UIKit

// swiftlint:disable identifier_name
struct LoginModel: Codable {
    
    let result: Int?
    let error_message: String?
    let data: UserData?
    
    private enum CodingKeys: String, CodingKey {
        case result
        case error_message
        case data
    }
}

struct UserData: Codable {
    
    let user: UserModel
    private enum CodingKeys: String, CodingKey {
        case user
    }
}

struct UserModel: Codable {
    
    let user_id: Int
    let user_name: String
    let user_profile_url: String
    let created_at: String
    
    private enum CodingKeys: String, CodingKey {
        case user_id
        case user_name
        case user_profile_url
        case created_at
    }
}

class UserInfoModel {
    
    static var result: Int?
    static var error_message: String?
    static var data: UserData?
    
    class func SetUserInfoData(model: LoginModel?) {
        self.result = model?.result
        self.error_message = model?.error_message
        self.data = model?.data
    }
}
