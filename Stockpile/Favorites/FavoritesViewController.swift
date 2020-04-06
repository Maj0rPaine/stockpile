//
//  FavoritesViewController.swift
//  Stockpile
//
//  Created by Chris Paine on 4/6/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UICollectionViewDelegate {
    let dataController = DataController.shared
        
    var collectionViewDataSource: ImageCollectionViewDataSource<Favorite, ImageCell>!
    
    let sectionInsets = UIEdgeInsets.zero
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(observeChanges(_:)), name: .NSManagedObjectContextObjectsDidChange, object: nil)
        
        collectionViewDataSource = ImageCollectionViewDataSource(collectionView: collectionView, configure: { (cell, favorite) in
            cell.loadFavorite(favorite: favorite)
        })
        
        fetchFavorites()
    }
    
    @objc func observeChanges(_ notification: Notification) {
        guard let keys = notification.userInfo?.keys else { return }
        
        if keys.contains(NSInsertedObjectsKey) || keys.contains(NSDeletedObjectsKey) {
            fetchFavorites()
        }
    }
    
    func fetchFavorites() {
        let images = dataController.viewContext.fetchFavorites()
        collectionViewDataSource.data = nil
        collectionViewDataSource.updateData(newData: images)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = collectionViewDataSource.data else { return }
        let controller = UINavigationController(rootViewController: ImageDetailViewController(favorite: data[indexPath.row]))
        present(controller, animated: true, completion: nil)
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
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

