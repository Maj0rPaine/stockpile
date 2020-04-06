//
//  TrendsDataSource.swift
//  Stockpile
//
//  Created by Chris Paine on 4/6/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

class TrendsDataSource: NSObject, UITableViewDataSource {
    var trends: ArraySlice<Trend> = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var tableView: UITableView!
    
    var searchProvider: SearchProvider!
    
    static let maxTrendCount = 5
    
    init(tableView: UITableView, searchProvider: SearchProvider) {
        super.init()
        self.tableView = tableView
        self.searchProvider = searchProvider

        tableView.dataSource = self
        tableView.register(TrendsCell.self, forCellReuseIdentifier: TrendsCell.identifier)

        fetchTrends()
    }
    
    func fetchTrends() {
        searchProvider.getTrends { [weak self] trends in
            guard let trends = trends else { return }
            
            DispatchQueue.main.async {
                self?.trends = trends.prefix(TrendsDataSource.maxTrendCount)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrendsCell.identifier, for: indexPath)
        cell.textLabel?.text = trends[indexPath.row].keyword
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return !trends.isEmpty ? NSLocalizedString("Trending Searches", comment: "") : ""
    }
}
