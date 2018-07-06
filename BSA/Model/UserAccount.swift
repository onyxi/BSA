//
//  UserAccount.swift
//  BSA
//
//  Created by Pete Holdsworth on 05/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

class UserAccount: Equatable {
    
    static func == (lhs: UserAccount, rhs: UserAccount) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String!
    let name: String!
    var securityLevel: Int!
    
    init(id: String, name: String, securityLevel: Int) {
        self.id = id
        self.name = name
        self.securityLevel = securityLevel
    }
    
}
