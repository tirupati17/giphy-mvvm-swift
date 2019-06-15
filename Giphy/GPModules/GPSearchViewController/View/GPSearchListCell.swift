//
//  GPSearchListCell.swift
//  Giphy
//
//  Created by Tirupati Balan on 10/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

class GPSearchListCell : GPCollectionViewCell {
    var controller: GPSearchViewControllerView?
    var isUpdatedConstraints: Bool? = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        addSubview(profileImageView)
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func favouriteAction() {
        
    }
    
    var gpImage : GPImage? {
        didSet {
            if let imageName = gpImage?.title {
                self.nameLabel.text = imageName.capitalized
            }
            if let profileImageUrl = gpImage?.images?.fixedWidth?.url {
                self.profileImageView.load(url: URL(string: profileImageUrl)!)
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder_photo")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.numberOfLines = 1
        return label
    }()
    
    let favouriteButton = GPSearchListCell.buttonForTitle("", imageName: "favourite_button")
    
    static func buttonForTitle(_ title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(UIColor.lightGray, for: UIControl.State())
        
        button.setImage(UIImage(named: imageName), for: UIControl.State())
        button.setImage(UIImage(named: "favourite_button_selected"), for: .selected)
        button.setImage(UIImage(named: "favourite_button_selected"), for: .highlighted)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        return button
    }
    
    func setupConstraints() {
        if (isUpdatedConstraints == false) {
            isUpdatedConstraints = true
            
            addConstraintsWithFormat("H:|-6-[v0]-6-|", views: profileImageView)
            addConstraintsWithFormat("V:|-3-[v0(200)]", views: profileImageView)
        }
    }}
