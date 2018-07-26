//
//  Staff.swift
//  BSA
//
//  Created by Pete Holdsworth on 28/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

class Staff: CustomStringConvertible, Equatable {
    
    // Properties:
    let id: String!
    let staffNumber: Int!
    let firstName: String!
    let lastName: String!
//    var schoolClassNumber: Int?
    
    // Custom initialiser
    init(id: String, staffNumber: Int, firstName: String, lastName: String) {
//         schoolClassNumber: Int?) {
        self.id = id
        self.staffNumber = staffNumber
        self.firstName = firstName
        self.lastName = lastName
//        self.schoolClassNumber = schoolClassNumber
    }
    
    
    // Conform to 'Equatable' protocol by comparing instances on their unique 'id' attribute
    static func == (lhs: Staff, rhs: Staff) -> Bool {
        return lhs.staffNumber == rhs.staffNumber
    }
    
    // Provides custom representation for printing of instances - in more readable format
    var description: String {
        let idString = String(describing: id)
        let staffNumberString = String(describing: staffNumber!)
        let firstNameString = String(describing: firstName!)
        let lastNameString = String(describing: lastName!)
//        let schoolClassNumberString = String(describing: schoolClassNumber)
        
        return "Staff object:\n Database_id: \(idString)\n Staff_Number: \(staffNumberString)\n First_Name: \(firstNameString)\n Last_Name: \(lastNameString)"
//        \n Assigned_Class: \(schoolClassNumberString)"
    }
    
    
}
