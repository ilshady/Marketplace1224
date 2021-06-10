//
//  LoginVC.swift
//  Marketplace
//
//  Created by Ilshat Khairakhun on 09.06.2021.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {
    
    lazy var loginView = LoginView()
    
    override func loadView() {
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.viewDelegate = self
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
    }
    
    func loginDidPressed() {
        loginAction()
    }
    
}

extension LoginViewController: LoginViewDelegate {
    
    func forgotDidPressed() {
        let forgotVC = WebViewController(with: "https://1224.kz/my-account/lost-password/")
        present(forgotVC, animated: true, completion: nil)
    }
    
    func registerDidPressed() {
        let registerVC = WebViewController(with: "https://1224.kz/my-account/")
        present(registerVC, animated: true, completion: nil)
    }
    
    @objc func loginAction() {
        
        let parameters = [
                "username" : loginView.emailTextField.text,
                "password" : loginView.passwordTextField.text
            ]
        ProgressHUD.show()
        NetworkManager.shared.request(url: APIUrls.generatedLoginUrl, method: .post, parameters: parameters) { (result: Result<UserResponseModel, ErrorModel>) in
            ProgressHUD.dismiss()
            switch result {
            case .failure(let error):
                self.showAlert(alertText: "Ошибка", alertMessage: error.message)
            case .success(let userModel):
                UserDefaults.standard.setValue(userModel.data?.token, forKey: "Token")
                self.updateApp()
            }
        }
        
    }
    
    
    func updateApp () {
        let viewController = TabBarController()
        
        guard
            let window = UIApplication.shared.keyWindow,
            let rootViewController = window.rootViewController
        else { return }
        
        viewController.view.frame = rootViewController.view.frame
        viewController.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = viewController
        })
        
    }
    
}

extension UIViewController {
    func showAlert(alertText : String, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
