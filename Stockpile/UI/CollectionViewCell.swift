//
//  CollectionViewCell.swift
//  Stockpile
//
//  Created by Chris Paine on 4/5/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

protocol Cell: class {
    static var reuseIdentifier: String { get }
}

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}
