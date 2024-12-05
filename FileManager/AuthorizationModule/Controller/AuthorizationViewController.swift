//
//  AuthorizationViewController.swift
//  Registration
//
//  Created by KOДИ on 19.02.2024.
//

import UIKit
import Combine

class AuthorizationViewController: UIViewController {
    
    private let viewModel = AuthorizationViewModel()
    private lazy var authorizationView = AuthorizationView(viewModel: viewModel)
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embedViews()
        setupConstraints()
        setupAppearance()
        setupBindings()
    }
    
    //MARK: - Private Methods
    
    private func setupAppearance() {
        view.backgroundColor = .white
        navigationItem.title = "Авторизация"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupBindings() {
        // Обработка результата авторизации
        viewModel.$loginResult
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                switch result {
                case .success(let user):
                    print("User logged in: \(user.name)")
                    self?.navigateToFileSystem()
                case .failure(let error):
                    self?.showLoginError(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func navigateToFileSystem() {
        let fileSystemVC = FileSystemViewController()
        navigationController?.pushViewController(fileSystemVC, animated: true)
    }
    
    private func showLoginError(_ error: Error) {
        let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Embed Views

private extension AuthorizationViewController {
    
    func embedViews() {
        view.addSubview(authorizationView)
    }
}

//MARK: - Constraints

private extension AuthorizationViewController {
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            authorizationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            authorizationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authorizationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            authorizationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
