//
//  Array + Extensions.swift
//  FileManager
//
//  Created by KOДИ on 18.08.2024.
//

import UIKit

extension Array {
    
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
