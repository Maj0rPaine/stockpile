//
//  SearchViewController.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    let searchProvider: SearchProvider = Networking()

    var trendsDataSource: TrendsDataSource!
    
    var resultsViewController = SearchResultsViewController()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchBar.placeholder = NSLocalizedString("Search Images", comment: "")
        searchController.searchBar.isTranslucent = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = resultsViewController
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
        trendsDataSource = TrendsDataSource(tableView: tableView, searchProvider: searchProvider)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            if let searchText = trendsDataSource.trends[indexPath.row].keyword {
                searchController.isActive = true
                initiateSearch(searchText: searchText)
            }
        } else {
            if let searchText = resultsViewController.recentSearchTableViewController.fetchedResultsController.object(at: indexPath).searchText {
                searchController.searchBar.resignFirstResponder()
                initiateSearch(searchText: searchText)
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.searchController.searchResultsController?.view.isHidden = false
        }
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
        searchController.searchBar.text = searchText
        resultsViewController.performSearch(searchText: searchText)
    }
}
