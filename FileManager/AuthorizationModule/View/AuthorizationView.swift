//
//  AuthorizationView.swift
//  Registration
//
//  Created by KOДИ on 04.03.2024.
//

import UIKit
import Combine

class AuthorizationView: UIView {
    
    // MARK: - ViewModel
    
    var viewModel: AuthorizationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Subviews
    
    let loginTextField = CustomTextField(placeholder: "Логин", keyBoardType: .default)
    let passwordTextField = CustomTextField(placeholder: "Пароль", keyBoardType: .default)
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вход", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var authorizationStackView: UIStackView = {
        UIStackView(arrangedSubviews: [loginTextField, passwordTextField, loginButton],
                    axis: .vertical,
                    spacing: 30)
    }()
    
    init(viewModel: AuthorizationViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setupAppearance()
        embedViews()
        setupConstraints()
        setupBindings()
    }
    
    private func setupAppearance() {
        backgroundColor = .white
        passwordTextField.isSecureText = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupBindings() {
        // Привязка текстовых полей к ViewModel
        loginTextField.textPublisher
            .assign(to: \.login, on: viewModel)
            .store(in: &cancellables)
        
        passwordTextField.textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        // Обновление состояния кнопки входа
        viewModel.$isLoginButtonEnabled
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)
        
        // Обработка нажатия кнопки входа
        loginButton.tapPublisher
            .sink { [weak self] in
                self?.viewModel.loginUser()
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Embed Views

private extension AuthorizationView {
    
    func embedViews() {
        addSubview(authorizationStackView)
    }
}

//MARK: - Constraints

private extension AuthorizationView {
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            authorizationStackView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            authorizationStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            authorizationStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
