//
//  Extension+UIImageView.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 09/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import Foundation
import UIKit

// An extension for UIImageView so we can load the image from the url given by th API 
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
