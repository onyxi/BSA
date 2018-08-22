//
//  Class.swift
//  BSA
//
//  Created by Pete Holdsworth on 02/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

struct SchoolClass: CustomStringConvertible, Equatable {
    
    // Properties:
    var id: String!
    var className: String!
    
    // Custom initialiser
    init (id: String, className: String) {
        self.id = id
        self.className = className
    }
    
    
    // Conform to 'Equatable' protocol by comparing instances on their unique 'id' attribute
    static func == (lhs: SchoolClass, rhs: SchoolClass) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Provides custom representation for printing of instances - in more readable format
    var description: String {
        let idString = String(describing: id)
        let classNameString = String(describing: className!)
        return "School Class object:\n Database_id: \(idString)\n Class_Name: \(classNameString)"
    }
    
}
