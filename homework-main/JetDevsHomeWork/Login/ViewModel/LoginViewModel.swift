//
//  LoginViewModel.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 14/12/22.
//

import RxSwift
import RxCocoa
import UIKit

class LoginViewModel {
    
    // MARK: - Dependencies
    @Inject private var jetDevsAPI: JetDevsAPI
    
    let email = PublishSubject<String>()
    let password = PublishSubject<String>()
    
    func login(email: String?,
               password: String?,
               onCompletion completion: @escaping (Error?) -> Void) {
        AppLoader.show(animated: true)
        let loginPara = LoginParam(email: email,
                                   password: password)
        jetDevsAPI.login(params: loginPara).execute { result in
            AppLoader.hide()
            switch result {
            case .success(let model):
                UserInfoModel.SetUserInfoData(model: model)
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func isTextFieldEntryButtonValid() -> Observable<Bool> {
        return Observable.combineLatest(email.asObserver().startWith(""), password.asObserver().startWith("")).map { email, password in
            if email.isEmpty || password.isEmpty {
                return false
            } else {
                return true
            }
        }.startWith(false)
    }
    
    func checkValidation(email: String?, password: String?) -> String {
        let errorString = ""
        if email == "" {
            return MessageString.email
        } else if !ValidatorClasses.isValidEmail(strEmail: (email ?? "")) {
            return MessageString.validEmail
        }
        if password == "" {
            return MessageString.password
        } else if (password?.count ?? 0) < 8 {
            return MessageString.validPassword
        }
        return errorString
    }
}
