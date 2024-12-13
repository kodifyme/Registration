//
//  RegistrationViewController.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit
import Combine

class RegistrationViewController: UIViewController {
    
    private let registrationView = RegistrationView()
    private var viewModel = RegistrationViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    override func loadView() {
        self.view = registrationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        bindViewModel()
    }
}

// MARK: - Setup appearance

private extension RegistrationViewController {
    
    func setupAppearance() {
        title = "Регистрация"
        view.backgroundColor = .white
    }
}

// MARK: - Bind ViewModel

private extension RegistrationViewController {
    
    func bindViewModel() {
        
        registrationView.numberTextPublisher
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewModel.states = .none
            })
            .assign(to: \.number, on: viewModel)
            .store(in: &cancellables)
        
        registrationView.emailTextPublisher
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewModel.states = .none
            })
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        registrationView.passwordTextPublisher
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewModel.states = .none
            })
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        registrationView.signUpButtonTapped
            .sink { [weak self] in
                self?.viewModel.submitRegistration()
            }
            .store(in: &cancellables)
        
        viewModel.isFormValid
            .sink { [weak self] isEnabled in
                guard let self else { return }
                
                self.registrationView.signUpButton.isEnabled = isEnabled
                self.registrationView.signUpButton.backgroundColor = isEnabled ? .black : .gray
                if !isEnabled {
                    self.registrationView.signUpButton.setTitle("Регистрация", for: .normal)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$states
            .sink { [weak self] states in
                switch states {
                case .loading:
                    self?.registrationView.signUpButton.backgroundColor = .systemGray
                    self?.registrationView.signUpButton.isEnabled = false
                    self?.registrationView.signUpButton.setTitle("Загрузка", for: .normal)
                case .success:
                    self?.registrationView.signUpButton.backgroundColor = .black
                    self?.registrationView.signUpButton.setTitle("Регистрация", for: .normal)
                case .failure:
                    self?.registrationView.signUpButton.backgroundColor = .red
                    self?.registrationView.signUpButton.setTitle("Проверьте введенные данные", for: .normal)
                case .none:
                    self?.registrationView.signUpButton.backgroundColor = .gray
                    self?.registrationView.signUpButton.setTitle("Регистрация", for: .normal)
                }
            }
            .store(in: &cancellables)
    }
}
