//
//  AuthView.swift
//  FileManager
//
//  Created by KOДИ on 11.12.2024.
//

import UIKit
import Combine
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import VKID

class AuthView: UIView {
    
    var vkid: VKID?
    
    // MARK: - Publishers
    
    let emailTextPublisher = PassthroughSubject<String, Never>()
    let passwordTextPublisher = PassthroughSubject<String, Never>()
    let nextFieldPublisher = PassthroughSubject<UITextField?, Never>()
    let signInButtonTapped = PassthroughSubject<Void, Never>()
    let signUpButtonTapped = PassthroughSubject<Void, Never>()
    let forgotPasswordTapped = PassthroughSubject<Void, Never>()
    let googleSignInPublisher = PassthroughSubject<Result<AuthDataResult, Error>, Never>()
    
    var getParentViewController: (() -> UIViewController?)?
    
    // MARK: - SubViews
    
    private let emailLabel: UILabel = {
        UILabel(
            text: "Email",
            font: .systemFont(ofSize: 16)
        )
    }()
    
    private let emailTextField = CustomTextField(
        placeholder: "Email",
        keyBoardType: .emailAddress,
        returnKeyType: .next,
        tag: 1,
        validType: .email
    )
    
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
    
    private lazy var passwordTextField = CustomTextField(
        placeholder: "Password",
        keyBoardType: .default,
        isPasswordField: true,
        returnKeyType: .done,
        tag: 2,
        validType: .password
    )
    
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
        button.setTitle("Вход", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
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
        button.addTarget(self, action: #selector(didTapGoogleLogin), for: .touchUpInside)
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
    
    private lazy var facebookButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Facebook")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(didTapFacebookLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var socialButtonsStackView: UIStackView = {
        UIStackView(
            arrangedSubviews: [googleButton, appleButton, facebookButton],
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
        button.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
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
        setDelegates()
    }
    
    private func setDelegates() {
        [emailTextField, passwordTextField].forEach { $0.delegate = self }
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
        signInButtonTapped.send()
    }
    
    @objc private func didTapSignUp() {
        signUpButtonTapped.send()
    }
    
    @objc private func didTapForgotPass() {
        forgotPasswordTapped.send()
    }
    
    @objc private func didTapGoogleLogin() {
        print("Tapped")
        guard let parentVC = getParentViewController?() else { return }
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: parentVC) { [weak self] result, error in
            if let error {
                self?.googleSignInPublisher.send(.failure(error))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self?.googleSignInPublisher.send(.failure(NSError(
                    domain: "SignIn",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey : "Не удалось получить токены"])))
                return
            }
            
            let credintal = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credintal) { result, error in
                if let error {
                    self?.googleSignInPublisher.send(.failure(error))
                } else if let result {
                    self?.googleSignInPublisher.send(.success(result))
                }
            }
        }
    }
//    
//    @objc private func didTapAppleLogin() {
//        print("Apple login tapped")
//    }
//    
    @objc private func didTapFacebookLogin() {
        print("VK login tapped")
        
    }
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

// MARK: - UITextFieldDelegate

extension AuthView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextField = superview?.viewWithTag(textField.tag + 1) as? UITextField
        nextFieldPublisher.send(nextField)
        return false
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
