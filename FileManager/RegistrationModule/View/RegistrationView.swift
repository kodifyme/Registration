//
//  RegistrationView.swift
//  FileManager
//
//  Created by KOДИ on 12.12.2024.
//

import UIKit
import Combine

class RegistrationView: UIView {
    
    // MARK: - Publishers
    
    let numberTextPublisher = PassthroughSubject<String, Never>()
    let emailTextPublisher = PassthroughSubject<String, Never>()
    let passwordTextPublisher = PassthroughSubject<String, Never>()
    let signUpButtonTapped = PassthroughSubject<Void, Never>()
    
    // MARK: - SubViews
    
    private let numberLabel: UILabel = {
        UILabel(
            text: "Номер телефона",
            font: .systemFont(ofSize: 16)
        )
    }()
    
    private let numberTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.keyboardType = .numberPad
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.black.cgColor
        textField.placeholder = "+7"
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        return textField
    }()
    
    private lazy var numberStackView: UIStackView = {
        UIStackView(
            arrangedSubviews: [numberLabel, numberTextField],
            axis: .vertical,
            distribution: .fill,
            spacing: 5,
            aligment: .fill
        )
    }()
    
    private let emailLabel: UILabel = {
        UILabel(
            text: "Email",
            font: .systemFont(ofSize: 16)
        )
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.black.cgColor
        textField.placeholder = "Email"
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        return textField
    }()
    
    private lazy var emailStackView: UIStackView = {
        UIStackView(
            arrangedSubviews: [emailLabel, emailTextField],
            axis: .vertical,
            distribution: .fill,
            spacing: 5,
            aligment: .fill
        )
    }()
    
    private let passwordLabel: UILabel = {
        UILabel(
            text: "Password",
            font: .systemFont(ofSize: 16)
        )
    }()
    
    //FIXME: - Need custom
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        let imageName = textField.isSecureTextEntry ? "eye.slash" : "eye"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.black.cgColor
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.rightViewMode = .always
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        
        let passwordToggleButton = UIButton(type: .custom)
        passwordToggleButton.tintColor = .gray
        passwordToggleButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        passwordToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        let rightViewContainer = UIView()
        rightViewContainer.addSubview(passwordToggleButton)
        rightViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        passwordToggleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightViewContainer.heightAnchor.constraint(equalToConstant: 24),
            rightViewContainer.widthAnchor.constraint(equalToConstant: 40),
            passwordToggleButton.centerYAnchor.constraint(equalTo: rightViewContainer.centerYAnchor),
            passwordToggleButton.trailingAnchor.constraint(equalTo: rightViewContainer.trailingAnchor, constant: -8)
        ])
        
        textField.rightView = rightViewContainer
        return textField
    }()
    
    private lazy var passwordStackView: UIStackView = {
        UIStackView(
            arrangedSubviews: [passwordLabel, passwordTextField],
            axis: .vertical,
            distribution: .fill,
            spacing: 5,
            aligment: .fill
        )
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let leftLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let signUpWithLabel: UILabel = {
        UILabel(
            text: "Или зарегистрируйтесь с помощью",
            textColor: .gray,
            font: .italicSystemFont(ofSize: 14),
            numberOfLines: 2,
            textAlignment: .center
        )
    }()
    
    //FIXME: - Layout
    private lazy var signUpWithStackView: UIStackView = {
        UIStackView(
            arrangedSubviews: [leftLine, signUpWithLabel, rightLine],
            axis: .horizontal,
            distribution: .fill,
            spacing: 8,
            aligment: .center
        )
    }()
    
    private lazy var googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Google")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.addTarget(self, action: #selector(didTapGoogleLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var appleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Apple")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.addTarget(self, action: #selector(didTapAppleLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var vkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "VK")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.addTarget(self, action: #selector(didTapVKLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var socialButtonsStackView: UIStackView = {
        UIStackView(
            arrangedSubviews: [googleButton, appleButton, vkButton],
            axis: .horizontal,
            distribution: .fillEqually,
            spacing: 10,
            aligment: .center
        )
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        embedViews()
        setupLayout()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @objc private func numberTextFieldChanged(_ sender: UITextField) {
        numberTextPublisher.send(sender.text ?? "")
    }
    
    @objc private func emailTextFieldChanged(_ sender: UITextField) {
        emailTextPublisher.send(sender.text ?? "")
    }
    
    @objc private func passwordTextFieldChanged(_ sender: UITextField) {
        passwordTextPublisher.send(sender.text ?? "")
    }
    
    @objc private func didTapSignUp() {
        signUpButtonTapped.send(())
    }
    
//    @objc private func didTapGoogleLogin() {
//        print("Google login tapped")
//    }
//    
//    @objc private func didTapAppleLogin() {
//        print("Apple login tapped")
//    }
//    
//    @objc private func didTapVKLogin() {
//        print("VK login tapped")
//    }
}

// MARK: - Bind Actions

private extension RegistrationView {
    
    func bindActions() {
        numberTextField.addTarget(self, action: #selector(numberTextFieldChanged(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged(_:)), for: .editingChanged)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
}

// MARK: - Embed view

private extension RegistrationView {
    
    func embedViews() {
        [numberStackView,
         emailStackView,
         passwordStackView,
         signUpButton,
         signUpWithStackView,
         socialButtonsStackView
        ].forEach { addSubview($0) }
    }
}

// MARK: - Setup Layout

private extension RegistrationView {
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            numberStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            numberStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            numberStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            emailStackView.topAnchor.constraint(equalTo: numberStackView.bottomAnchor, constant: 20),
            emailStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            passwordStackView.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 20),
            passwordStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            passwordStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            signUpButton.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor, constant: 35),
            signUpButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpWithStackView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 35),
            signUpWithStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            signUpWithStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            socialButtonsStackView.topAnchor.constraint(equalTo: signUpWithStackView.bottomAnchor, constant: 20),
            socialButtonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            socialButtonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            numberTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            //Lines
            rightLine.heightAnchor.constraint(equalToConstant: 1),
            rightLine.widthAnchor.constraint(equalTo: signUpWithLabel.widthAnchor, multiplier: 0.3),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            leftLine.widthAnchor.constraint(equalTo: signUpWithLabel.widthAnchor, multiplier: 0.3),
            
        ])
    }
}
