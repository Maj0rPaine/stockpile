//
//  ImageCollectionViewCell.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
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

class ImageCell: UICollectionViewCell, Cell {    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        return imageView
    }()
    
    let placeholderImage = UIImage(systemName: "photo")
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = placeholderImage
    }
}

extension ImageCell {
    func loadImage(photo: Photo, searchProvider: SearchProvider?) {
        imageView.image = placeholderImage

        guard let stringURL = photo.urls?.regular,
            let url = URL(string: stringURL) else { return }
        
        searchProvider?.getImage(url: url) { [weak self] (image) in
            DispatchQueue.main.async {
                self?.imageView.image = image                
            }
        }
    }
    
    func loadFavorite(favorite: Favorite) {
        guard let data = favorite.data,
            let image = UIImage(data: data) else { return }
        imageView.image = image
    }
}
