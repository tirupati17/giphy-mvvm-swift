//
//  UICollection+Extensions.swift
//  Giphy
//
//  Created by Tirupati Balan on 10/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
