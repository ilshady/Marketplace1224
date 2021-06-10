//
//  LoginView.swift
//  Marketplace
//
//  Created by Ilshat Khairakhun on 09.06.2021.
//

import UIKit

protocol LoginViewDelegate {
    func loginDidPressed()
    func forgotDidPressed()
    func registerDidPressed()
}

class LoginView: UIView {
    
    var viewDelegate: LoginViewDelegate?
    
    let logoImageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "market_logo")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let emailTextField: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 14)
        text.layer.cornerRadius = 5
        text.layer.masksToBounds = true
        text.layer.borderWidth = 1
        text.setLeftPaddingPoints(10)
        text.keyboardType = .emailAddress
        text.textContentType = .emailAddress
        text.layer.borderColor = UIColor.systemGray5.cgColor
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Email"
        return text
    }()
    
    let passwordTextField: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 14)
        text.isSecureTextEntry = true
        text.textContentType = .password
        text.layer.cornerRadius = 5
        text.layer.masksToBounds = true
        text.layer.borderWidth = 1
        text.isSecureTextEntry = true
        text.setLeftPaddingPoints(10)
        text.layer.borderColor = UIColor.systemGray5.cgColor
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Пароль"
        return text
    }()
    
    let forgotButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Забыли пароль", for: .normal)
        button.addTarget(self, action: #selector(handleForgotButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.setTitle("Вход", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5176470588, green: 0.7607843137, blue: 0.08235294118, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    let extraButton: UIButton = {
        let button = UIButton()
        button.setTitle("Если вы еще не зарегестрированы. Регистрация", for: .normal)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis  = .vertical
        stackView.spacing = 10
        addSubview(stackView)
        
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(forgotButton)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(extraButton)
        
        NSLayoutConstraint.activate([
            
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: stackView.topAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            forgotButton.rightAnchor.constraint(equalTo: stackView.rightAnchor),

            loginButton.heightAnchor.constraint(equalToConstant: 45),
            
            extraButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
            
        ])
    }
    
}

extension LoginView {
    @objc func handleLogin() {
        viewDelegate?.loginDidPressed()
    }
    
    @objc func handleForgotButton() {
        viewDelegate?.forgotDidPressed()
    }
    
    @objc func handleRegister() {
        viewDelegate?.registerDidPressed()
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

