//
//  UIImage+Cache.swift
//  Stockpile
//
//  Created by Chris Paine on 4/5/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

extension UIImage {
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    func cache(with key: String) {
        UIImage.imageCache.setObject(self, forKey: key as AnyObject)
    }
}
