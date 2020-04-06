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
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchImages() -> [Image]? {
        guard let objects = try? fetch(Image.fetchRequest()) as? [Image] else { return nil }
        return objects
    }
    
    func fetchImage(_ id: String) -> Image? {
        let imageFetch: NSFetchRequest<Image> = Image.fetchRequest()
        imageFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Image.id), id)
        
        guard let results = try? fetch(imageFetch) else { return nil }
        return results.first
    }
}
