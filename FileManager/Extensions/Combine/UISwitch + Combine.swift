//
//  UISwitch + Combine.swift
//  FileManager
//
//  Created by KOДИ on 04.12.2024.
//

import UIKit
import Combine

extension UISwitch {
    var isOnPublisher: AnyPublisher<Bool, Never> {
        Publishers.ControlProperty(
            control: self,
            events: [.valueChanged],
            keyPath: \.isOn
        )
        .eraseToAnyPublisher()
    }
}
