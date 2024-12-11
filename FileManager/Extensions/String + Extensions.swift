//
//  String + Extensions.swift
//  Registration
//
//  Created by KOДИ on 16.02.2024.
//

import Foundation

extension String {
    
    enum ValidTypes {
        case email
        case phoneNumber
        case password
    }
    
    enum Regex: String {
        case email = "^[A-Za-z0-9._%+-]+@(mail\\.ru|gmail\\.com|bk\\.ru)$"
        case phoneNumber = "^(\\+7|8)\\d{10}$"
        case password = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}"
    }
    
    func isValid(validType: ValidTypes) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validType {
        case .email:
            regex = Regex.email.rawValue
        case .phoneNumber:
            regex = Regex.phoneNumber.rawValue
        case .password:
            regex = Regex.password.rawValue
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}
