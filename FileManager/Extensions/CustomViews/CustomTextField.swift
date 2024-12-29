//
//  CustomTextField.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit

final class CustomTextField: UITextField {
    
    // MARK: - Properties
    
    private lazy var passwordToggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .gray
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightViewContainer: UIView = {
        let view = UIView()
        view.addSubview(passwordToggleButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 24),
            view.widthAnchor.constraint(equalToConstant: 40),
            passwordToggleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordToggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        return view
    }()
    
    var isPasswordField: Bool = false {
        didSet {
            configurePasswordField()
        }
    }
    
    // MARK: - Init
    
    init(
        placeholder: String,
        keyBoardType: UIKeyboardType,
        isPasswordField: Bool = false
    ) {
        super.init(frame: .zero)
        self.keyboardType = keyBoardType
        self.placeholder = placeholder
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        self.isPasswordField = isPasswordField
        translatesAutoresizingMaskIntoConstraints = false
        
        if isPasswordField {
            configurePasswordField()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func configurePasswordField() {
        isSecureTextEntry = true
        rightViewMode = .always
        rightView = rightViewContainer
    }
    
    @objc private func togglePasswordVisibility() {
        isSecureTextEntry.toggle()
        let imageName = isSecureTextEntry ? "eye.slash" : "eye"
        passwordToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
