//
//  String+Date.swift
//  Stockpile
//
//  Created by Chris Paine on 4/5/20.
//  Copyright © 2020 ChrisPaine. All rights reserved.
//

import Foundation

extension String {
    func fullDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = formatter.date(from: self) {
            formatter.dateStyle = .full
            return formatter.string(from: date)
        }
        
        return self
    }
}
