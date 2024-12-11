//
//  UILabel + Extensions.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit

extension UILabel {
    
    convenience init(
        text: String,
        font: UIFont
    ) {
        self.init()
        self.text = text
        self.font = font
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(
        text: String,
        textColor: UIColor,
        font: UIFont,
        numberOfLines: Int,
        textAlignment: NSTextAlignment
    ) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
    }
}
