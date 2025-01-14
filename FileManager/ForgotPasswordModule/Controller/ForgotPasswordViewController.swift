//
//  ForgotPasswordViewController.swift
//  FileManager
//
//  Created by KOДИ on 13.12.2024.
//

import UIKit
import Combine

class ForgotPasswordViewController: UIViewController {
    
    private let forgotPasswordView = ForgotPasswordView()
    private let viewModel = ForgotPasswordViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    override func loadView() {
        self.view = forgotPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        bindViewModel()
        initializeHideKeyboard()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Setup appearance

private extension ForgotPasswordViewController {
    
    func setupAppearance() {
        view.backgroundColor = .white
        title = "Восстановление пароля"
    }
}

// MARK: - Bind ViewModel

private extension ForgotPasswordViewController {
    
    func bindViewModel() {
        forgotPasswordView.emailTextPublisher
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewModel.states = .none
            })
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        forgotPasswordView.sendButtonTapped
            .sink { [weak self] in
                self?.viewModel.sendResetEmail()
            }
            .store(in: &cancellables)
        
        viewModel.isValidEmailPublisher
            .sink { [weak self] isEnabled in
                guard let self else { return }
                
                self.forgotPasswordView.sendButton.isEnabled = isEnabled
                self.forgotPasswordView.sendButton.backgroundColor = isEnabled ? .black : .gray
                if !isEnabled {
                    self.forgotPasswordView.sendButton.setTitle("Отправить", for: .normal)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$states
            .sink { [weak self] states in
                switch states {
                case .loading:
                    self?.forgotPasswordView.sendButton.backgroundColor = .systemGray
                    self?.forgotPasswordView.sendButton.isEnabled = false
                    self?.forgotPasswordView.sendButton.setTitle("Загрузка", for: .normal)
                case .success:
                    self?.forgotPasswordView.sendButton.backgroundColor = .black
                    self?.forgotPasswordView.sendButton.setTitle("Отправить", for: .normal)
                case .failure:
                    self?.forgotPasswordView.sendButton.backgroundColor = .red
                    self?.forgotPasswordView.sendButton.setTitle("Проверьте введенные данные", for: .normal)
                case .none:
                    self?.forgotPasswordView.sendButton.backgroundColor = .gray
                    self?.forgotPasswordView.sendButton.setTitle("Отправить", for: .normal)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Gesture Recognizer

private extension ForgotPasswordViewController {
    
    func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        view.addGestureRecognizer(tap)
    }
}
