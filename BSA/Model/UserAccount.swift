//
//  UserAccount.swift
//  BSA
//
//  Created by Pete Holdsworth on 05/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

class UserAccount: Equatable {
    
    // Properties:
    let id: String!
    let accountName: String!
    var securityLevel: Int!
    var schoolClassId: String?
    var password: String!
    
    // Custom initialiser
    init(id: String, accountName: String, securityLevel: Int, schoolClassId: String?, password: String) {
        self.id = id
        self.accountName = accountName
        self.securityLevel = securityLevel
        self.schoolClassId = schoolClassId
        self.password = password
    }
    
    // Conform to 'Equatable' protocol by comparing instances on their unique 'id' attribute
    static func == (lhs: UserAccount, rhs: UserAccount) -> Bool {
        return lhs.id == rhs.id
    }
    
}
