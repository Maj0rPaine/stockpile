//
//  ImageCollectionViewCell.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let identifier: String = "\(ImageCell.self)"
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension ImageCell {
    func configure(with photo: Photo) {
        if let description = photo.description {
            let label = UILabel()
            label.textColor = .white
            label.text = description
            label.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
        }
    }
}
