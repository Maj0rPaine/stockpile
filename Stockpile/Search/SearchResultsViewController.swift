//
//  SearchResultsViewController.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {
    let searchSuggestionTableViewController = SuggestionTableViewController()
    let imageCollectionViewController = ImageCollectionViewController()
}

extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("Update search results")

        // TODO: Figure out why searchSuggestion view isn't loaded when deleting search text
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            searchSuggestionTableViewController.remove()
            add(imageCollectionViewController)
        } else {
            imageCollectionViewController.remove()
            add(searchSuggestionTableViewController)
        }
    }
}
