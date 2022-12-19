//
//  LoginViewController.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 14/12/22.
//

import RxSwift
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Veriable
    private let loginViewModel = LoginViewModel()
    private let disposed = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setRxSwift()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Action
    @IBAction func closeButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        self.view.endEditing(true)
        let checkValid = loginViewModel.checkValidation(
            email: emailTextField.text,
            password: passwordTextField.text)
        if checkValid.isEmpty {
            self.loginTap()
        } else {
            let alert = UIAlertController(title: MessageString.oops, message: checkValid, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: MessageString.okkk, style: UIAlertAction.Style.default, handler: { _ in
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: false, completion: nil)
            }
        }
    }
    
}

// MARK: - Supporting Function

extension LoginViewController {
    
    func setRxSwift() {
        
        emailTextField.rx.text.map { $0 ?? ""}.bind(to: loginViewModel.email).disposed(by: disposed)
        
        passwordTextField.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.password).disposed(by: disposed)
        
        loginViewModel.isTextFieldEntryButtonValid().bind(to: loginButton.rx.isUserInteractionEnabled).disposed(by: disposed)
        
        loginViewModel.isTextFieldEntryButtonValid().map { $0 ? UIColor.primaryColor : UIColor.placeHolderColor}.bind(to: loginButton.rx.backgroundColor).disposed(by: disposed)
        
        self.setView()
    }
    
    private func setView() {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.emailTextField.setTextFieldUI()
        self.passwordTextField.setTextFieldUI()
        self.loginButton.layer.cornerRadius = 6.0
        self.setDelegate()
    }
    
    private func setDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
}

// MARK: - LoginIn

extension LoginViewController {
    
    func loginTap() {
        loginViewModel.login(email: (emailTextField.text ?? ""), password: (passwordTextField.text ?? "")) { [weak self] error in
            if let error = error {
                print("error--->\(error)")
                let alert = UIAlertController(title: MessageString.oops, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: MessageString.okkk, style: UIAlertAction.Style.default, handler: { _ in
                }))
                DispatchQueue.main.async {
                    self?.present(alert, animated: false, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: MessageString.success, message: MessageString.loginSuccess, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: MessageString.okkk, style: UIAlertAction.Style.default, handler: { _ in
                    self?.navigationController?.popViewController(animated: true)
                }))
                DispatchQueue.main.async {
                    self?.present(alert, animated: false, completion: nil)
                }
            }
        }
    }
}

// MARK: - TextField Delegate

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " && range.location == 0 && range.length == 0 {
            return false
        }
        if textField == emailTextField {
            let validCharactersSet = NSCharacterSet(charactersIn: ValidatorClasses.emailAcceptableCharacter).inverted
            let filter = string.components(separatedBy: validCharactersSet)
            if filter.count == 1 {
                let newlength = (textField.text?.count ?? 0) + string.count - range.length
                return newlength < 51
            }
            return false
        } else if textField == passwordTextField {
            let newLength = (textField.text?.count ?? 0) + string.count - range.length
            return newLength <= 51
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
}
