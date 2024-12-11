//
//  UISegmentedControl + Combine.swift
//  FileManager
//
//  Created by KOДИ on 04.12.2024.
//

import UIKit
import Combine

extension UISegmentedControl {
    var selectedSegmentIndexPublisher: AnyPublisher<Int, Never> {
        Publishers.ControlProperty(
            control: self,
            events: .valueChanged,
            keyPath: \.selectedSegmentIndex
        )
        .eraseToAnyPublisher()
    }
}
