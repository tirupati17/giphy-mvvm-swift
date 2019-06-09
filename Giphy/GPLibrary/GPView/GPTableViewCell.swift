//
//  GPTableViewCell.swift
//  Giphy
//
//  Created by Tirupati Balan on 09/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//


class GPTableViewCell : UITableViewCell {
    func getButton(_ tag : Int) -> UIButton {
        return self.viewWithTag(tag) as! UIButton
    }
    
    func getLabel(_ tag : Int) -> UILabel {
        return self.viewWithTag(tag) as! UILabel
    }
    
    func getField(_ tag : Int) -> UITextField {
        return self.viewWithTag(tag) as! UITextField
    }
    
    func getView(_ tag : Int) -> UIView {
        return self.viewWithTag(tag)!
    }
}
