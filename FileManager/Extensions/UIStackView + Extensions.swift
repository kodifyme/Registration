//
//  UIStackView + Extensions.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView],
                     axis: NSLayoutConstraint.Axis,
                     distribution: UIStackView.Distribution,
                     spacing: CGFloat,
                     aligment: UIStackView.Alignment) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
        self.alignment = aligment
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
