//
//  GPSearchListCell.swift
//  Giphy
//
//  Created by Tirupati Balan on 10/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

class GPSearchListCell : GPTableViewCell {
    var controller: GPSearchViewControllerView?
    var isUpdatedConstraints: Bool? = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(favouriteButton)
        
        favouriteButton.addTarget(self, action: #selector(favouriteAction), for: .touchUpInside)
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
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.init(white: 0.96, alpha: 1).cgColor
        imageView.layer.borderWidth = 1
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
            
            addConstraintsWithFormat("H:|-16-[v0(40)]-16-[v1][v2(40)]-32-|", views: profileImageView, nameLabel, favouriteButton)
            
            addConstraintsWithFormat("V:|-12-[v0(40)]", views: profileImageView)
            addConstraintsWithFormat("V:|-24-[v0(16)]", views: nameLabel)
            addConstraintsWithFormat("V:|-12-[v0(40)]", views: favouriteButton)
        }
    }}
