//
//  PhotosCollectionViewController.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    var imageProvider: ImageProvider!
    
    var photoResults: PhotoResults? {
        didSet {
            self.collectionViewDataSource.updateData(newData: photoResults?.photos)
        }
    }
        
    var collectionViewDataSource: ImageCollectionViewDataSource<Photo, PhotoCell>!
            
    let sectionInsets = UIEdgeInsets.zero

    convenience init(imageProvider: ImageProvider) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.imageProvider = imageProvider
        
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionViewDataSource = ImageCollectionViewDataSource(collectionView: collectionView, configure: { [weak self] (cell, photo) in
            cell.loadImage(photo: photo, imageProvider: self?.imageProvider)
        })
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Present details
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let count = collectionViewDataSource.data?.count,
            indexPath.row == count - 1 {
            imageProvider.nextPage(nextURL: photoResults?.nextURL) { [weak self] (results: PhotoResults?) in
                self?.photoResults = results
            }
        }
    }
}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
