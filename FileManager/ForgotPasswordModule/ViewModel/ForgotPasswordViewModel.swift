//
//  ForgotPasswordViewModel.swift
//  FileManager
//
//  Created by KOДИ on 13.12.2024.
//

import Foundation
import Combine

class ForgotPasswordViewModel {
    
    // MARK: - Input
    
    @Published var email: String = ""
    
    // MARK: - Output
    
    @Published var states: AuthStates = .none
    
    // MARK: - Publishers
    
    var isValidEmailPublisher: AnyPublisher<Bool, Never> {
        $email
            .map { $0.isValid(validType: .email) }
            .eraseToAnyPublisher()
    }
    
    func sendResetEmail() {
        states = .loading
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            
            if self.isEmailValid() {
                self.states = .success
            } else {
                self.states = .failure
                print("Ошибка авторизации: неверный email или пароль")
            }
        }
    }
    
    func isEmailValid() -> Bool {
        email == "admin@bk.ru"
    }
}
