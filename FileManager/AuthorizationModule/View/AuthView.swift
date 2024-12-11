//
//  AuthView.swift
//  FileManager
//
//  Created by KOДИ on 11.12.2024.
//

import UIKit
import Combine

class AuthView: UIView {
    
    // MARK: - Publishers
    
    let emailTextPublisher = PassthroughSubject<String, Never>()
    let passwordTextPublisher = PassthroughSubject<String, Never>()
    let signInButtonTapped = PassthroughSubject<Void, Never>()
    
    // MARK: - SubViews
    
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
    
    private lazy var forgotButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Забыли пароль?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .italicSystemFont(ofSize: 14)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(didTapForgotPass), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gray
        button.setTitle("Вход", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = true
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
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
    
    private let loginWithLabel: UILabel = {
        UILabel(
            text: "Или войдите с помощью",
            textColor: .gray,
            font: .italicSystemFont(ofSize: 14),
            numberOfLines: 2,
            textAlignment: .center
        )
    }()
    
    private lazy var loginWithStackView: UIStackView = {
        UIStackView(
            arrangedSubviews: [leftLine, loginWithLabel, rightLine],
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
    
    private let noAccountLabel: UILabel = {
        UILabel(
            text: "Еще не регистрировались?",
            font: .italicSystemFont(ofSize: 14)
        )
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .clear
        //        button.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpStackView: UIStackView = {
        UIStackView(
            arrangedSubviews: [noAccountLabel, signUpButton],
            axis: .horizontal,
            distribution: .fill,
            spacing: 8,
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
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @objc private func emailTextFieldChanged(_ sender: UITextField) {
        emailTextPublisher.send(sender.text ?? "")
    }
    
    @objc private func passwordTextFieldChanged(_ sender: UITextField) {
        passwordTextPublisher.send(sender.text ?? "")
    }
    
    @objc private func didTapSignIn() {
        signInButtonTapped.send(())
    }
    
    @objc private func didTapForgotPass() {
       
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

// MARK: - Embed view

private extension AuthView {
    
    func embedViews() {
        [emailStackView,
         passwordStackView,
         forgotButton,
         loginButton,
         loginWithStackView,
         socialButtonsStackView,
         signUpStackView
        ].forEach { addSubview($0) }
    }
}

// MARK: - Bind Actions

private extension AuthView {
    
    func bindActions() {
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged(_:)), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
}

// MARK: - Setup Layout

private extension AuthView {
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            emailStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            emailStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            passwordStackView.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 20),
            passwordStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            passwordStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            forgotButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            forgotButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            
            loginButton.topAnchor.constraint(equalTo: forgotButton.bottomAnchor, constant: 35),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            loginWithStackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 35),
            loginWithStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            loginWithStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            socialButtonsStackView.topAnchor.constraint(equalTo: loginWithStackView.bottomAnchor, constant: 20),
            socialButtonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            socialButtonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            rightLine.heightAnchor.constraint(equalToConstant: 1),
            leftLine.widthAnchor.constraint(equalTo: loginWithLabel.widthAnchor, multiplier: 0.5),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            rightLine.widthAnchor.constraint(equalTo: loginWithLabel.widthAnchor, multiplier: 0.5),
            
            signUpStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            signUpStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
