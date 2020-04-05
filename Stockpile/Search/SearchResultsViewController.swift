//
//  SearchResultsViewController.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {
    let imageProvider: ImageProvider = Networking()

    var suggestionTableViewController: SuggestionTableViewController!
    var photosCollectionViewController: PhotosCollectionViewController!
    var collectionsCollectionViewController: CollectionsCollectionViewController!
    
    var selectedScope: SearchScope = .photos
    
    var currentCollectionViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViewControllers()
        setViewController(suggestionTableViewController)
    }
    
    func initializeViewControllers() {
        suggestionTableViewController = SuggestionTableViewController()
        photosCollectionViewController = PhotosCollectionViewController(imageProvider: imageProvider)
        collectionsCollectionViewController = CollectionsCollectionViewController(imageProvider: imageProvider)
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
        updateViewController(searchController: searchController)
    }

    func setScope(scope: Int, searchController: UISearchController) {
        self.selectedScope = SearchScope(rawValue: scope) ?? .photos
        updateViewController(searchController: searchController)
        performSearch(searchController: searchController)
    }
    
    func updateViewController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
        !searchText.isEmpty {
            if selectedScope == .photos {
                setViewController(photosCollectionViewController)
            } else {
                setViewController(collectionsCollectionViewController)
            }
        } else {
            setViewController(suggestionTableViewController)
        }
    }
        
    func performSearch(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
        !searchText.isEmpty {
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
        }
    }
    
    func clearResults() {
        photosCollectionViewController.photoResults = nil
        collectionsCollectionViewController.collectionResults = nil
    }
    
    func resetResultsViewController() {
        setViewController(suggestionTableViewController)
    }
}
