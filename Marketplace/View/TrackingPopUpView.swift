//
//  TrackingPopUpView.swift
//  Marketplace
//
//  Created by Ilshat Khairakhun on 02.05.2021.
//

import UIKit

protocol TrackingPopUpViewDelegate {
    func checkButtonPressed()
}

class TrackingPopUpView: UIView {
    
    var viewDelegate: TrackingPopUpViewDelegate?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите номер договора"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.5176470588, green: 0.7607843137, blue: 0.08235294118, alpha: 1)
        return label
    }()
    
    let trackingInputTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.cornerRadius = 2
        text.layer.borderWidth = 1
        text.layer.borderColor = #colorLiteral(red: 0.5176470588, green: 0.7607843137, blue: 0.08235294118, alpha: 1)
        text.keyboardType = .numberPad
        text.textAlignment = .center
        text.layer.masksToBounds = true
        text.placeholder = "Номер заказа"
        return text
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.5176470588, green: 0.7607843137, blue: 0.08235294118, alpha: 1)
        button.layer.cornerRadius = 2
        button.layer.masksToBounds = true
        button.setTitle("Принять заказ".uppercased(), for: .normal)
        button.addTarget(self, action: #selector(handleCheckButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(trackingInputTextField)
        addSubview(checkButton)
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            
            trackingInputTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            trackingInputTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            trackingInputTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            trackingInputTextField.heightAnchor.constraint(equalToConstant: 40),
            
            checkButton.topAnchor.constraint(equalTo: trackingInputTextField.bottomAnchor, constant: 10),
            checkButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            checkButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            checkButton.heightAnchor.constraint(equalToConstant: 40),
            checkButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackingPopUpView {
    
    @objc func handleCheckButton() {
        viewDelegate?.checkButtonPressed()
    }
}

