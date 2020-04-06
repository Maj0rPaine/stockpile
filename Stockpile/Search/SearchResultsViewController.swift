//
//  SearchResultsViewController.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

protocol SearchResultsDelegate: class {
    func didSelectPhoto(photo: Photo)
}

class SearchResultsViewController: UIViewController {
    let imageProvider: ImageProvider = Networking()
    
    let dataController = DataController.shared

    var recentSearchTableViewController: RecentSearchTableViewController!
    
    var photosCollectionViewController: PhotosCollectionViewController!
    
    var collectionsCollectionViewController: CollectionsCollectionViewController!
    
    var selectedScope: SearchScope = .photos
    
    var currentCollectionViewController: UIViewController?
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        
        initializeViewControllers()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController(recentSearchTableViewController)
    }
    
    func initializeViewControllers() {
        recentSearchTableViewController = RecentSearchTableViewController()
        photosCollectionViewController = PhotosCollectionViewController(imageProvider: imageProvider, delegate: self)
        collectionsCollectionViewController = CollectionsCollectionViewController(imageProvider: imageProvider, delegate: self)
    }
    
    func setViewController(_ controller: UIViewController) {
        guard controller != currentCollectionViewController else { return }
        currentCollectionViewController?.remove()
        add(controller)
        currentCollectionViewController = controller
        print("Current results controller: ", currentCollectionViewController)
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("Update search results")
        updateViewController(searchText: searchController.searchBar.text)
    }

    func setScope(scope: Int, searchText: String?) {
        self.selectedScope = SearchScope(rawValue: scope) ?? .photos
        updateViewController(searchText: searchText)
        performSearch(searchText: searchText)
    }
    
    func updateViewController(searchText: String?) {
        if let searchText = searchText, !searchText.isEmpty {
            if selectedScope == .photos {
                setViewController(photosCollectionViewController)
            } else {
                setViewController(collectionsCollectionViewController)
            }
        } else {
            setViewController(recentSearchTableViewController)
        }
    }
        
    func performSearch(searchText: String?) {
        if let searchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty {
            clearResults()
            
            if selectedScope == .photos {
                imageProvider.fetch(resource: .searchPhotos(query: searchText)) { [weak self] (results: PhotoResults?) in
                    self?.photosCollectionViewController.photoResults = results
                }
            } else {
                imageProvider.fetch(resource: .searchCollections(query: searchText)) { [weak self] (results: CollectionResults?) in
                    self?.collectionsCollectionViewController.collectionResults = results
                }
            }
            
            saveSearchText(searchText: searchText)
        }
    }
    
    func saveSearchText(searchText: String) {
        if dataController.viewContext.fetchSearch(searchText) == nil {
            let newSearch = Search(context: dataController.viewContext)
            newSearch.searchText = searchText
            dataController.viewContext.saveChanges()
        }
    }
    
    func clearResults() {
        photosCollectionViewController.photoResults = nil
        collectionsCollectionViewController.collectionResults = nil
    }
}

extension SearchResultsViewController: SearchResultsDelegate {
    func didSelectPhoto(photo: Photo) {
        let controller = UINavigationController(rootViewController: ImageDetailViewController(photo: photo))
        present(controller, animated: true, completion: nil)
    }
}
