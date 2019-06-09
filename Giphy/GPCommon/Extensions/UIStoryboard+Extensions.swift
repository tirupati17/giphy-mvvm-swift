//
//  UIStoryboard+Extensions.swift
//  Giphy
//
//  Created by Tirupati Balan on 09/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

extension UIStoryboard {
    
    enum Storyboard : String {
        case main
        case launchScreen
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier : String { get }
}

extension StoryboardIdentifiable where Self : UIViewController { //Protocol implementation of storyboardIdentifier declared in GPViewController
    static var storyboardIdentifier : String {
        return String(describing : self)
    }
}
