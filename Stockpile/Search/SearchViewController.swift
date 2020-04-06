//
//  SearchViewController.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

class SuggestionPresenter: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

class SearchViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var resultsViewController = SearchResultsViewController()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchBar.placeholder = NSLocalizedString("Search Images", comment: "")
        searchController.searchBar.isTranslucent = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        //searchController.searchResultsUpdater = resultsViewController
        searchController.searchBar.scopeButtonTitles = SearchScope.buttonTitles
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        tableView.delegate = self
        resultsViewController.recentSearchTableViewController.tableView.delegate = self
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            print("Selected trend")
        } else {
            if let searchText = resultsViewController.recentSearchTableViewController.fetchedResultsController.object(at: indexPath).searchText {
                initiateSearch(searchText: searchText)
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Did begin editing")
        DispatchQueue.main.async {
            self.searchController.searchResultsController?.view.isHidden = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsViewController.updateViewController(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsViewController.clearResults()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resultsViewController.performSearch(searchText: searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        resultsViewController.setScope(scope: selectedScope, searchText: searchBar.text)
    }
    
    func initiateSearch(searchText: String) {
        resultsViewController.updateViewController(searchText: searchText)
        resultsViewController.performSearch(searchText: searchText)
        searchController.searchBar.resignFirstResponder()
    }
}
