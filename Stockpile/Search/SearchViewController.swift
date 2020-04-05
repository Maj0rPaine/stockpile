//
//  SearchViewController.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    var resultsViewController: SearchResultsViewController!
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsViewController = SearchResultsViewController()
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchBar.placeholder = NSLocalizedString("Search Images", comment: "")
        searchController.searchBar.isTranslucent = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = resultsViewController
        searchController.searchBar.scopeButtonTitles = SearchScope.buttonTitles
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Did begin editing")
        DispatchQueue.main.async {
            self.searchController.searchResultsController?.view.isHidden = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resultsViewController.performSearch(searchController: searchController)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        resultsViewController.selectedScope = SearchScope(rawValue: selectedScope) ?? .photos
        resultsViewController.performSearch(searchController: searchController)
    }
}
