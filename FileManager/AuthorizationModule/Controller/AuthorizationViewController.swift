//
//  AuthorizationViewController.swift
//  Registration
//
//  Created by KOДИ on 19.02.2024.
//

import UIKit
import Combine

class AuthorizationViewController: UIViewController {
    
    private var authView = AuthView()
    private var viewModel = AuthViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    override func loadView() {
        self.view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupAppearance()
        bindViewModel()
    }
}

// MARK: - Setup Navigation Bar

private extension AuthorizationViewController {
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Setup appearance

private extension AuthorizationViewController {
    
    private func setupAppearance() {
        title = "Вход"
        view.backgroundColor = .white
    }
}

// MARK: - Bind ViewModel

private extension AuthorizationViewController {
    
    func bindViewModel() {
        
        authView.emailTextPublisher
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewModel.states = .none
            })
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        authView.passwordTextPublisher
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewModel.states = .none
            })
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        authView.signInButtonTapped
            .sink { [weak self] in
                self?.viewModel.submitAuth()
            }
            .store(in: &cancellables)
        
        authView.signUpButtonTapped
            .sink { [weak self] in
                self?.present(UINavigationController(rootViewController: RegistrationViewController()), animated: true)
            }
            .store(in: &cancellables)
        
        authView.forgotPasswordTapped
            .sink { [weak self] in
                self?.present(UINavigationController(rootViewController: ForgotPasswordViewController()), animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.isFormValid
            .sink { [weak self] isEnabled in
                guard let self else { return }
                
                self.authView.loginButton.isEnabled = isEnabled
                self.authView.loginButton.backgroundColor = isEnabled ? .black : .gray
                if !isEnabled {
                    self.authView.loginButton.setTitle("Вход", for: .normal)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$states
            .sink { [weak self] states in
                switch states {
                case .loading:
                    self?.authView.loginButton.backgroundColor = .systemGray
                    self?.authView.loginButton.isEnabled = false
                    self?.authView.loginButton.setTitle("Загрузка", for: .normal)
                case .success:
                    self?.authView.loginButton.backgroundColor = .black
                    self?.authView.loginButton.setTitle("Вход", for: .normal)
                case .failure:
                    self?.authView.loginButton.backgroundColor = .red
                    self?.authView.loginButton.setTitle("Проверьте введенные данные", for: .normal)
                case .none:
                    self?.authView.loginButton.backgroundColor = .gray
                    self?.authView.loginButton.setTitle("Вход", for: .normal)
                }
            }
            .store(in: &cancellables)
    }
}
