//
//  UIButton + Combine.swift
//  FileManager
//
//  Created by KOДИ on 04.12.2024.
//

import UIKit
import Combine

extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        Publishers.ControlEvent(control: self, events: .touchUpInside)
            .eraseToAnyPublisher()
    }
}
