//
//  Constants.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit

let screenFrame: CGRect = UIScreen.main.bounds
let screenWidth = screenFrame.size.width
let screenHeight = screenFrame.size.height
let isIPhoneX = (screenWidth >= 375.0 && screenHeight >= 812.0) ? true : false
let isIPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? true : false
let statusBarHeight: CGFloat = isIPhoneX ? 44.0 : 20.0
let navigationBarHeight: CGFloat = 44.0
let statusBarNavigationBarHeight: CGFloat = isIPhoneX ? 88.0 : 64.0
let tabbarSafeBottomMargin: CGFloat = isIPhoneX ? 34.0 : 0.0
let tabBarHeight: CGFloat = isIPhoneX ? (tabBarTrueHeight+34.0) : tabBarTrueHeight
let tabBarTrueHeight: CGFloat = 49.0

enum MessageString {
    static let email = "Email"
    static let password = "Password"
    static let validEmail = "Enter Valid Email"
    static let validPassword = "Enter Valid Password"
    static let networkError = "No network available, Check your connection and try again."
    static let oops = "Oops"
    static let okkk = "OK"
    static let success = "Success"
    static let loginSuccess = "Login Successfully."
    static let created = "Created "
    static let somethingWentWrong = "Something went wrong, please try again."
}

enum HTTPHeaderField {
    static let authorization = "Authorization"
    static let contentType = "Content-Type"
    static let acceptType = "Accept"
    static let acceptEncoding = "Accept-Encoding"
}

enum ContentType {
    static let json = "application/json"
    static let javascript = "text/javascript"
    static let formUrlEncoded = "application/x-www-form-urlencoded; charset=utf-8"
}
