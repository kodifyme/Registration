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
        //        setupLayout()
        
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
    
    private func bindViewModel() {
        authView.emailTextPublisher
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        authView.passwordTextPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        authView.signInButtonTapped
            .sink { [weak self] in
                self?.viewModel.submitAuth()
            }
            .store(in: &cancellables)
        
        viewModel.isAuthEnabled
            .sink { [weak self] isEnabled in
                self?.authView.loginButton.isEnabled = isEnabled
                self?.authView.loginButton.backgroundColor = isEnabled ? .black : .gray
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
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Setup Layout

private extension AuthorizationViewController {
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            authView.topAnchor.constraint(equalTo: view.topAnchor),
            authView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            authView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
