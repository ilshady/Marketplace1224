//
//  TrackingPopUpView.swift
//  Marketplace
//
//  Created by Ilshat Khairakhun on 02.05.2021.
//

import UIKit

class TrackingPopUpView: UIView {
    
    let trackingInputTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .blue
        text.placeholder = "Введите выданный номер для трекинга заказа"
        return text
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.setTitle("Проверить".uppercased(), for: .normal)
        //button.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(trackingInputTextField)
        addSubview(checkButton)
        
        NSLayoutConstraint.activate([
            trackingInputTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            trackingInputTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            trackingInputTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10),
            
            checkButton.topAnchor.constraint(equalTo: trackingInputTextField.bottomAnchor, constant: 50),
            checkButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            checkButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10),
            checkButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

