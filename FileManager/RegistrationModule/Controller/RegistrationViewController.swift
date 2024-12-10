//
//  RegistrationViewController.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit
import Combine

class RegistrationViewController: UIViewController {
    
    // MARK: - SubViews
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя"
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.black.cgColor
        textField.placeholder = "Имя"
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        return textField
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        return label
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
        let stackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        return label
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
        let stackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
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
        let label = UILabel()
        label.text = "Или зарегистрируйтесь с помощью"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .italicSystemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    //FIXME: - Layout
    private lazy var signUpWithStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftLine, signUpWithLabel, rightLine])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "globe"), for: .normal)
        button.setTitle(" Google", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(didTapGoogleLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var appleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "applelogo"), for: .normal)
        button.setTitle(" Apple", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(didTapAppleLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var vkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "network"), for: .normal)
        button.setTitle(" VK", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(didTapVKLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var socialButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [googleButton, appleButton, vkButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupAppearance()
        embedViews()
        setupLayout()
    }
    
    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @objc private func didTapGoogleLogin() {
        print("Google login tapped")
    }
    
    @objc private func didTapAppleLogin() {
        print("Apple login tapped")
    }
    
    @objc private func didTapVKLogin() {
        print("VK login tapped")
    }
}

// MARK: - Setup Navigation Bar

private extension RegistrationViewController {
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Setup appearance

private extension RegistrationViewController {
    
    func setupAppearance() {
        title = "Регистрация"
        view.backgroundColor = .white
    }
}

// MARK: - Embed view

private extension RegistrationViewController {
    
    func embedViews() {
        [nameStackView,
         emailStackView,
         passwordStackView,
         signUpButton,
         signUpWithStackView,
         socialButtonsStackView
        ].forEach { view.addSubview($0) }
    }
}

// MARK: - Setup Layout

private extension RegistrationViewController {
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            nameStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            nameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailStackView.topAnchor.constraint(equalTo: nameStackView.bottomAnchor, constant: 20),
            emailStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passwordStackView.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 20),
            passwordStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signUpButton.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor, constant: 35),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpWithStackView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 35),
            signUpWithStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signUpWithStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            socialButtonsStackView.topAnchor.constraint(equalTo: signUpWithStackView.bottomAnchor, constant: 20),
            socialButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            socialButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
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
