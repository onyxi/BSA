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
//    let accountNumber: Int!
    let accountName: String!
    var securityLevel: Int!
    var schoolClassId: String?
    
    // Custom initialiser
    init(id: String, accountName: String, securityLevel: Int, schoolClassId: String?) {
//         accountNumber: Int, accountName: String, securityLevel: Int, schoolClassNumber: Int?) {
        self.id = id
//        self.accountNumber = accountNumber
        self.accountName = accountName
        self.securityLevel = securityLevel
        self.schoolClassId = schoolClassId
    }
    
    // Conform to 'Equatable' protocol by comparing instances on their unique 'id' attribute
    static func == (lhs: UserAccount, rhs: UserAccount) -> Bool {
        return lhs.id == rhs.id
    }
    
}
