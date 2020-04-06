//
//  NSManagedObject+Favorite.swift
//  Stockpile
//
//  Created by Chris Paine on 4/6/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import CoreData

extension Favorite {
    convenience init(id: String, data: Data, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id
        self.data = data
        context.saveChanges()
    }
}
