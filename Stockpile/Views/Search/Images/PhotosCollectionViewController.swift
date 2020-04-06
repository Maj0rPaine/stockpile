//
//  PhotosCollectionViewController.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    var searchProvider: SearchProvider!
    
    weak var delegate: SearchResultsDelegate?
    
    var photoResults: PhotoResults? {
        didSet {
            self.collectionViewDataSource.updateData(newData: photoResults?.photos)
        }
    }
        
    var collectionViewDataSource: ImageCollectionViewDataSource<Photo, ImageCell>!
            
    let sectionInsets = UIEdgeInsets.zero

    convenience init(searchProvider: SearchProvider, delegate: SearchResultsDelegate) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.searchProvider = searchProvider
        self.delegate = delegate
        
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        collectionViewDataSource = ImageCollectionViewDataSource(collectionView: collectionView, configure: { [weak self] (cell, photo) in
            cell.loadImage(photo: photo, searchProvider: self?.searchProvider)
        })
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = collectionViewDataSource.data else { return }
        delegate?.didSelectPhoto(photo: data[indexPath.row])
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let count = collectionViewDataSource.data?.count,
            indexPath.row == count - 1 {
            searchProvider.nextPage(nextURL: photoResults?.nextURL) { [weak self] (results: PhotoResults?) in
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
