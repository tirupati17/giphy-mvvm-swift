//
//  GPError.swift
//  Giphy
//
//  Created by Tirupati Balan on 09/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

protocol LocalizedDescriptionError: Error {
    var localizedDescription: String { get }
}

public enum GPError : LocalizedDescriptionError {
    case invalidArray(model: String)
    case invalidDictionary(model: String)
    case customError(message: String)
    
    var localizedDescription: String {
        switch self {
        case .invalidArray(model: let model):
            return "\(model) has an invalid array"
        case .invalidDictionary(model: let model):
            return "\(model) has an invalid dictionary"
        case .customError(message: let message):
            return "\(message)"
        }
    }
}
