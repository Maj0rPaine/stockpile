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
    let suggestionTableViewController = SuggestionTableViewController()
    let imageCollectionViewController = ImageCollectionViewController()
    
    var selectedScope: SearchScope = .photos
    
    func updateView() {
        if selectedScope == .photos {
            imageCollectionViewController.remove()
            add(suggestionTableViewController)
        } else {
            suggestionTableViewController.remove()
            add(imageCollectionViewController)
        }
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("Update search results")

        // TODO: Figure out why suggestion tableview is not displayed
        if let searchText = searchController.searchBar.text,
        !searchText.isEmpty {
            suggestionTableViewController.remove()
            add(imageCollectionViewController)
        } else {
            imageCollectionViewController.remove()
            add(suggestionTableViewController)
        }
    }
    
    func performSearch(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
        !searchText.isEmpty {
            imageProvider.search(query: searchText, scope: selectedScope) { [weak self] photos in
                if let photos = photos {
                    DispatchQueue.main.async {
                        self?.imageCollectionViewController.photos = photos
                    }
                }
            }
        }
    }
}
