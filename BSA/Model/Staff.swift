//
//  Staff.swift
//  BSA
//
//  Created by Pete Holdsworth on 28/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

class Staff: Equatable {
    
    static func == (lhs: Staff, rhs: Staff) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    let id: String!
    let firstName: String!
    let lastName: String!
    
    init(id: String, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
    
}
