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
        searchController.searchBar.placeholder = "Search Images"
        searchController.searchBar.isTranslucent = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = resultsViewController
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
        guard let searchText = searchBar.text else { return }
        
        // TODO: Query images with searchText
    }
}
