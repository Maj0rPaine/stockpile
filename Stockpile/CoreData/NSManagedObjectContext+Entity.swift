//
//  NSManageObjectContext+Entity.swift
//  Stockpile
//
//  Created by Chris Paine on 4/5/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func saveChanges() {
        if self.hasChanges {
            do {
                try save()
                print("Context saved")
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchFavorites() -> [Favorite]? {
        guard let objects = try? fetch(Favorite.fetchRequest()) as? [Favorite] else { return nil }
        return objects
    }
    
    func fetchFavorite(_ id: String) -> Favorite? {
        let imageFetch: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        imageFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Favorite.id), id)
        
        guard let results = try? fetch(imageFetch) else { return nil }
        return results.first
    }
}
