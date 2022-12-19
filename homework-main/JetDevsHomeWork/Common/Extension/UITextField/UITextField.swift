//
//  UITextField.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 14/12/22.
//

import Foundation
import UIKit
// swiftlint: disable empty_first_line
extension UITextField {
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    func setTextFieldUI() {
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.placeHolderColor.cgColor
        self.layer.borderWidth = 0.5
        self.addPadding(.both(20))
    }
    
    func addPadding(_ padding: PaddingSide) {
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        switch padding {
        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always
        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // Left
            self.leftView = paddingView
            self.leftViewMode = .always
            // Right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}
