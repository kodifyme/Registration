//
//  ForgotPasswordView.swift
//  FileManager
//
//  Created by KOДИ on 13.12.2024.
//

import UIKit
import Combine

class ForgotPasswordView: UIView {
    
    // MARK: - Publishers
    
    let emailTextPublisher = PassthroughSubject<String, Never>()
    let sendButtonTapped = PassthroughSubject<Void, Never>()
    
    // MARK: - SubViews
    
    private let emailLabel: UILabel = {
        UILabel(
            text: "Введите email для восстановления пароля",
            font: .systemFont(ofSize: 16)
        )
    }()
    
    private let emailTextField = CustomTextField(
        placeholder: "Email",
        keyBoardType: .emailAddress,
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
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отправить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    @objc private func emailTextFieldChanged(_ sender: UITextField) {
        emailTextPublisher.send(sender.text ?? "")
    }
        
    @objc private func didTapSendButton() {
        sendButtonTapped.send(())
    }
}

// MARK: - Embed view

private extension ForgotPasswordView {
    
    func embedViews() {
        [emailStackView,
         sendButton
        ].forEach { addSubview($0) }
    }
}

// MARK: - Bind Actions

private extension ForgotPasswordView {
    
    func bindActions() {
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged(_:)), for: .editingChanged)
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
    }
}

// MARK: - Setup Layout

private extension ForgotPasswordView {
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            emailStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            emailStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            sendButton.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 35),
            sendButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sendButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
