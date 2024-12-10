//
//  RegistrationViewModel.swift
//  FileManager
//
//  Created by KOДИ on 04.12.2024.
//

import Foundation
import Combine

class RegistrationViewModel {
    // Input
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var age: Int = 6
    @Published var genderIndex: Int = 0
    @Published var isNoticeEnabled: Bool = true
    
    // Output
    @Published private(set) var isFormValid: Bool = false
    @Published private(set) var ageText: String = "Возраст: 6"
    @Published private(set) var registrationResult: Result<User, Error>?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        // Обновление текста возраста при изменении значения слайдера
        $age
            .map { "Возраст: \($0)" }
            .assign(to: \.ageText, on: self)
            .store(in: &cancellables)
        
        // Валидация формы
        Publishers.CombineLatest3($name, $phoneNumber, $password)
            .map { [unowned self] name, phone, password in
                let isValid = self.validateName(name) && self.validatePhoneNumber(phone) && self.validatePassword(password)
                print("isFormValid: \(isValid)")
                return isValid
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }
    
    private func validateName(_ name: String) -> Bool {
        let isValid = !name.isEmpty
        print("Name is valid: \(isValid)")
        return isValid
    }

    private func validatePhoneNumber(_ phone: String) -> Bool {
        let isValid = !phone.isEmpty
        print("Phone is valid: \(isValid)")
        return isValid
    }

    private func validatePassword(_ password: String) -> Bool {
        let isValid = password.count >= 6
        print("Password is valid: \(isValid)")
        return isValid
    }
    
    // Метод регистрации пользователя
    func registerUser() {
        let user = User(name: name, phoneNumber: phoneNumber, password: password, userID: UUID().uuidString)
        UserDefaultsManager.shared.registerUser(user)
        registrationResult = .success(user)
    }
}
