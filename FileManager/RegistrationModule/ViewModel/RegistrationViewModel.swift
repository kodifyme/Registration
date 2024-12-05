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
                return self.validateName(name) && self.validatePhoneNumber(phone) && self.validatePassword(password)
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }
    
    // Методы валидации
    private func validateName(_ name: String) -> Bool {
        return name.isValid(validType: .name)
    }
    
    private func validatePhoneNumber(_ phone: String) -> Bool {
        return phone.isValid(validType: .phoneNumber)
    }
    
    private func validatePassword(_ password: String) -> Bool {
        return password.isValid(validType: .password)
    }
    
    // Метод регистрации пользователя
    func registerUser() {
        let user = User(name: name, phoneNumber: phoneNumber, password: password, userID: UUID().uuidString)
        // Здесь может быть сетевой запрос или сохранение пользователя локально
        UserDefaultsManager.shared.registerUser(user)
        registrationResult = .success(user)
    }
}
