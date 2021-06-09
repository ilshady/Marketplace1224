//
//  LoginViewController.swift
//  Marketplace
//
//  Created by Нуржан Орманали on 24.02.2021.
//

import UIKit
import Alamofire
import ProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        hideKeyboardWhenTappedAround()
    }
    
    private func setupUI() {
        loginButton.layer.cornerRadius = 8
        emailTextField.delegate = self
    }
    
    private func performValidation() {
        if !emailTextField.text!.isValidEmail() {
            emailTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            emailTextField.layer.borderWidth = 1
            emailTextField.layer.cornerRadius = 5
            emailTextField.layer.masksToBounds = true
        } else {
            emailTextField.layer.borderWidth = 0
            emailTextField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        guard let emailText = emailTextField.text, !emailText.isEmpty else {
            showAlert(alertText: "Ошибка", alertMessage: "Заполните e-mail адрес")
            return
        }
        
        guard let passwordText = passwordTextField.text, !passwordText.isEmpty else {
            showAlert(alertText: "Ошибка", alertMessage: "Заполните пароль")
            return
        }
        
        let parameters = [
            "username" : emailText,
            "password" : passwordText
        ]
        ProgressHUD.show()
        NetworkManager.shared.request(url: APIUrls.generatedLoginUrl, method: .post, parameters: parameters) { (result: Result<UserResponseModel, ErrorModel>) in
            ProgressHUD.dismiss()
            switch result {
            case .failure(let error):
                self.showAlert(alertText: "Ошибка", alertMessage: error.message)
            case .success(let userModel):
                UserDefaults.standard.setValue(userModel.data?.token, forKey: "Token")
            }
        }
        
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

extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        performValidation()
    }
}
