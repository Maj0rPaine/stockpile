//
//  RecentSearchTableViewController.swift
//  Stockpile
//
//  Created by Chris Paine on 4/4/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import UIKit
import CoreData

class RecentSearchTableViewController: UITableViewController {
    var fetchedResultsController: NSFetchedResultsController<Search>!
    
    convenience init() {
        self.init(style: .grouped)
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        fetchedResultsController = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(RecentSearchCell.self, forCellReuseIdentifier: RecentSearchCell.identifier)
        
        let fetchRequest: NSFetchRequest<Search> = Search.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "searchText", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController<Search>(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "Search")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?.first else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath)
        cell.textLabel?.text = entity.searchText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Recent Searches", comment: "")
    }
}

extension RecentSearchTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            tableView.reloadData()
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
