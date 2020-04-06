//
//  DataController.swift
//  Stockpile
//
//  Created by Chris Paine on 4/5/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    static let shared = DataController(modelName: "Stockpile")
    
    let persisentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persisentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext!
    
    init(modelName: String) {
        persisentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load() {
        persisentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError()
            }

            self.configureContexts()
        }
    }
    
    func configureContexts() {
        // Set merge changes and policies
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
}
