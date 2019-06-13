//
//  UIImageView+Extensions.swift
//  Giphy
//
//  Created by Tirupati Balan on 10/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

extension UIImageView {
    func load(url: URL) {
        let serialQueue = DispatchQueue(label: "serial")
        serialQueue.async { [weak self] in
            guard let stringSelf = self else { return }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            stringSelf.image = image
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
