//
//  CollectionsCollectionViewController.swift
//  Stockpile
//
//  Created by Chris Paine on 4/5/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

class CollectionsCollectionViewController: UICollectionViewController {
    var searchProvider: SearchProvider!
    
    weak var delegate: SearchResultsDelegate?
    
    var collectionResults: CollectionResults? {
        didSet {
            self.collectionViewDataSource.updateData(newData: collectionResults?.photos)
        }
    }
        
    var collectionViewDataSource: ImageCollectionViewDataSource<Photo, ImageCell>!
            
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
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
            searchProvider.nextPage(nextURL: collectionResults?.nextURL) { [weak self] (results: CollectionResults?) in
                self?.collectionResults = results
            }
        }
    }
}

extension CollectionsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - sectionInsets.left - sectionInsets.right, height: collectionView.bounds.height / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
}
