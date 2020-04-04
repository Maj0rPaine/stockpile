//
//  SuggestionTableViewController.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit

class SuggestionCell: UITableViewCell {
    static let identifier: String = "\(SuggestionCell.self)"
}

class SuggestionTableViewController: UITableViewController {
    var data: [Int] = Array(0..<10)
    
    convenience init() {
        self.init(style: .grouped)
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SuggestionCell.self, forCellReuseIdentifier: SuggestionCell.identifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionCell.identifier, for: indexPath)
        cell.textLabel?.text = "\(data[indexPath.row])"
        return cell
    }
}
