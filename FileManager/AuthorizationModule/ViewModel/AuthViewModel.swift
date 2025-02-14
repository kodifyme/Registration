//
//  AuthViewModel.swift
//  FileManager
//
//  Created by KOДИ on 11.12.2024.
//

import UIKit
import Combine

class AuthViewModel {
    
    // MARK: - Input
    
    @Published var email = ""
    @Published var password = ""
    
    // MARK: - Output
    
    @Published var states: AuthStates = .none
    
    // MARK: - Publishers
    
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
        Publishers.CombineLatest(isValidEmailPublisher, isValidPasswordPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    func submitAuth() {
        states = .loading

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            
            if self.isCorrectAuth() {
                self.states = .success
            } else {
                self.states = .failure
                print("Ошибка авторизации: неверный email или пароль")
            }
        }
    }
    
    func isCorrectAuth() -> Bool {
        email == "admin@bk.ru" && 
        password == "Admin1"
    }
}
