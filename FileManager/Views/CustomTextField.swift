//
//  CustomTextField.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit

protocol TextFieldDelegate: AnyObject {
    func setText(to text: String?)
    func setBorderColor(_ color: UIColor)
}

final class CustomTextField: UITextField {
    
    //MARK: - Properties
    var isValid: Bool = false
    
    var isSecureText: Bool = false {
        didSet {
            self.isSecureTextEntry = isSecureText
        }
    }
    
    //MARK: - Subviews
    let border: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Initialization
    init(placeholder: String, keyBoardType: UIKeyboardType) {
        super.init(frame: .zero)
        self.keyboardType = keyBoardType
        self.placeholder = placeholder
        translatesAutoresizingMaskIntoConstraints = false
        
        setupView()
        configureBorderConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    private func setupView() {
        addSubview(border)
    }
    
    func setTextField(textField: UITextField, validType: String.ValidTypes, validMessage: String, wrongMessage: String, string: String, range: NSRange) {
        
        guard let currentText = textField.text,
              let textRange = Range(range, in: currentText) else { return }
        
        let updateText = currentText.replacingCharacters(in: textRange, with: string)
        
        let allowedCharacters: CharacterSet
        switch validType {
        case .name:
            allowedCharacters = CharacterSet.letters
        case .phoneNumber:
            allowedCharacters = CharacterSet.decimalDigits
        case .password:
            allowedCharacters = CharacterSet.letters
        }
        
        let containsOnlyAllowedCharacters = string.rangeOfCharacter(from: allowedCharacters.inverted) == nil
        
        if containsOnlyAllowedCharacters {
            textField.text = updateText
            
            if updateText.isEmpty {
                border.backgroundColor = .gray
            } else {
                let isValid = updateText.isValid(validType: validType)
                border.backgroundColor = isValid ? .systemGreen : .red
            }
        }
    }
}

//MARK: - TextFieldDataSource
extension CustomTextField: TextFieldDelegate {
    
    func setText(to text: String?) {
        self.text = text
    }
    
    func setBorderColor(_ color: UIColor) {
        border.backgroundColor = color
    }
}

//MARK: - Configure Border Constraints
private extension CustomTextField {
    func configureBorderConstraints() {
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: leadingAnchor),
            border.trailingAnchor.constraint(equalTo: trailingAnchor),
            border.bottomAnchor.constraint(equalTo: bottomAnchor),
            border.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
