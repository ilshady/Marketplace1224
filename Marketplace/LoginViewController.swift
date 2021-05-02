//
//  LoginViewController.swift
//  Marketplace
//
//  Created by Нуржан Орманали on 24.02.2021.
//

import UIKit
import Alamofire
import MKProgress

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        loginButton.layer.cornerRadius = 8
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
        
        MKProgress.show()
        NetworkManager.shared.request(url: APIUrls.generatedLoginUrl, method: .post, parameters: parameters) { (result: Result<UserResponseModel, ErrorModel>) in
            MKProgress.hide()
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
    //Show a basic alert
    func showAlert(alertText : String, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: nil))
        //Add more actions as you see fit
        self.present(alert, animated: true, completion: nil)
    }
}

