//
//  RegistrationViewModel.swift
//  FileManager
//
//  Created by KOДИ on 12.12.2024.
//

import UIKit
import Combine


class RegistrationViewModel {
    
    // MARK: - Input
    
    @Published var number: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    // MARK: - Output
    
    @Published var states: AuthStates = .none
    
    // MARK: - Publishers
    
    var isValidNumberPublisher: AnyPublisher<Bool, Never> {
        $number
            .map { $0.isValid(validType: .phoneNumber) }
            .eraseToAnyPublisher()
    }
    
    var isValidEmailPublisher: AnyPublisher<Bool, Never> {
        $email
            .map { $0.isValid(validType: .email) }
            .eraseToAnyPublisher()
    }
    
    var isValidPasswordPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { $0.isValid(validType: .password) }
            .eraseToAnyPublisher()
    }
    
    var isFormValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isValidNumberPublisher, isValidEmailPublisher, isValidPasswordPublisher)
            .map { $0 && $1 && $2 }
            .eraseToAnyPublisher()
    }
    
    func submitRegistration() {
        states = .loading
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            
            if self.isCorrectRegistration() {
                self.states = .success
            } else {
                self.states = .failure
                print("Ошибка авторизации: неверный email или пароль")
            }
        }
    }
    
    private func isCorrectRegistration() -> Bool {
        number == "89995287578" &&
        email == "admin@bk.ru" &&
        password == "Admin1"
    }
}
