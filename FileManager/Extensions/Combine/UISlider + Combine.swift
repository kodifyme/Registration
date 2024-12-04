//
//  UISlider + Combine.swift
//  FileManager
//
//  Created by KOДИ on 04.12.2024.
//

import UIKit
import Combine

extension UISlider {
    var valuePublisher: AnyPublisher<Float, Never> {
        Publishers.ControlProperty(control: self, events: [.valueChanged], keyPath: \.value)
            .eraseToAnyPublisher()
    }
}
