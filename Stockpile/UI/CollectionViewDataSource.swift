//
//  CollectionViewDataSource.swift
//  Stockpile
//
//  Created by Chris Paine on 4/5/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

class ImageCollectionViewDataSource<DataType: Any, CellType: UICollectionViewCell>: NSObject, UICollectionViewDataSource {
    var collectionView: UICollectionView!

    var data: [DataType]?
    
    var configure: ((CellType, DataType) -> Void)?
            
    init(collectionView: UICollectionView, configure: @escaping (CellType, DataType) -> Void) {
        super.init()
        self.collectionView = collectionView
        self.collectionView.dataSource = self
        self.configure = configure
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = data else { return 0 }
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.reuseIdentifier, for: indexPath) as! CellType
        cell.backgroundColor = .black
        
        if let item = data?[indexPath.row] {
            configure?(cell, item)
        }
        
        return cell
    }
    
    func updateData(newData: [DataType]?) {
        if self.data != nil, let newData = newData {
            DispatchQueue.main.async {
                let paths = Array(0..<newData.count).map { IndexPath(row: $0 + (self.data?.count ?? 0), section: 0)}
                self.data?.append(contentsOf: newData)
                self.collectionView?.insertItems(at: paths)
            }
        } else {
            DispatchQueue.main.async {
                self.data = newData
                self.collectionView.reloadData()
            }
        }
    }
}
