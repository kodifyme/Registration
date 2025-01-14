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
        initializeHideKeyboard()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
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
        
        registrationView.getParentViewController = { [weak self] in
            self
        }
        
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
        
        registrationView.nextFieldPublisher
            .sink { [weak self] nextField in
                nextField?.becomeFirstResponder()
                if nextField == nil {
                    self?.view.endEditing(true)
                }
            }
            .store(in: &cancellables)
        
        registrationView.signUpButtonTapped
            .sink { [weak self] in
                if ((self?.viewModel.submitRegistration()) != nil) {
                    self?.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
        
        // Google auth
        registrationView.googleSignInPublisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Ошибка авторизации через Google: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] result in
                // MARK: - FIX
                switch result {
                case .success:
                    
                    print("Успешный вход через Google: \(result.map {$0.user.email})")
                case .failure(let error):
                    print(error.localizedDescription)
                }
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

// MARK: - Gesture Recognizer

private extension RegistrationViewController {
    
    func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        view.addGestureRecognizer(tap)
    }
}
