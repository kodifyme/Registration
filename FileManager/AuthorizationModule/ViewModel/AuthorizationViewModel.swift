//
//  AuthorizationViewModel.swift
//  FileManager
//
//  Created by KOДИ on 05.12.2024.
//

import Foundation
import Combine

class AuthorizationViewModel {
    // Input
    @Published var login: String = ""
    @Published var password: String = ""
    
    // Output
    @Published private(set) var isLoginButtonEnabled: Bool = false
    @Published private(set) var loginResult: Result<User, Error>?
    
    private var cancellables = Set<AnyCancellable>()
    private let userManager = UserDefaultsManager.shared
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        // Валидация формы
        Publishers.CombineLatest($login, $password)
            .map { login, password in
                return !login.isEmpty && !password.isEmpty
            }
            .assign(to: \.isLoginButtonEnabled, on: self)
            .store(in: &cancellables)
    }
    
    func loginUser() {
        guard let user = userManager.getUser(for: login, password: password) else {
            loginResult = .failure(LoginError.invalidCredentials)
            return
        }
        userManager.setLoginStatus(isLoggedIn: true)
        userManager.saveCurrentUsername(user.name)
        loginResult = .success(user)
    }
    
    enum LoginError: Error {
        case invalidCredentials
    }
}
