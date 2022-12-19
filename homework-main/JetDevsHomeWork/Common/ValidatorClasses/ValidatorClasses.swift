//
//  ValidatorClasses.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 14/12/22.
//

import Foundation

// swiftlint: disable colon legacy_constructor
class ValidatorClasses: NSObject {
    
    static let emailAcceptableCharacter = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.-@"
    class func isValidEmail(strEmail:String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^([a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~:<>;\"()_-]+)@{1}(([a-zA-Z0-9_-]{1,67})|([a-zA-Z0-9-]+\\.[a-zA-Z0-9-]{1,67}))\\.(([a-zA-Z]{2,10})(\\.[a-zA-Z]{2,10})?)$", options: .caseInsensitive)
            return regex.firstMatch(in: strEmail, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, strEmail.count)) != nil
        } catch {
            return false
        }
    }
}
