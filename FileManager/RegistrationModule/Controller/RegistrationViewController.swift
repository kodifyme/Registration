//
//  RegistrationViewController.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit
import Combine

class RegistrationViewController: UIViewController {
    
    private let viewModel = RegistrationViewModel()
    private lazy var registrationView = RegistrationView(viewModel: viewModel)
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(registrationView)
        setupConstraints()
        setupBindings()
    }
    
    private func setupBindings() {
        // Обработка нажатия кнопки регистрации
        registrationView.registerButtonTapped
            .sink { [weak self] in
                self?.viewModel.registerUser()
            }
            .store(in: &cancellables)
        
        // Обработка нажатия кнопки пропуска
        registrationView.skipButtonTapped
            .sink { [weak self] in
                self?.navigateToNextScreen()
            }
            .store(in: &cancellables)
        
        // Наблюдение за результатом регистрации
        viewModel.$registrationResult
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                switch result {
                case .success(let user):
                    print("User registered: \(user)")
                    self?.navigateToNextScreen()
                case .failure(let error):
                    print("Registration failed: \(error)")
                    self?.showRegistrationError(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func navigateToNextScreen() {
        navigationController?.pushViewController(AuthorizationViewController(), animated: true)
    }
    
    private func showRegistrationError(_ error: Error) {
        let alert = UIAlertController(title: "Ошибка регистрации", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            registrationView.topAnchor.constraint(equalTo: view.topAnchor),
            registrationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registrationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            registrationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
