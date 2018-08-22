//
//  Student.swift
//  BSA
//
//  Created by Pete Holdsworth on 19/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

class Student: CustomStringConvertible, Equatable {

    // properties:
    let id: String!
    let studentNumber: Int!
    let firstName: String!
    let lastName: String!
    var schoolClassId: String!
    
    // Custom initialiser
    init(id: String!, studentNumber: Int, firstName: String, lastName: String, schoolClassId: String) {
        self.id = id
        self.studentNumber = studentNumber
        self.firstName = firstName
        self.lastName = lastName
        self.schoolClassId = schoolClassId
    }
    
    // Conform to 'Equatable' protocol by comparing instances on their unique 'id' attribute
    static func == (lhs: Student, rhs: Student ) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Provides custom representation for printing of instances - in more readable format
    var description: String {
        let idString = String(describing: id)
        let studentNumberString = String(describing: studentNumber!)
        let firstNameString = String(describing: firstName!)
        let lastNameString = String(describing: lastName!)
        let schoolClassIdString = String(describing: schoolClassId)
        
        return "Student object:\n Database_id: \(idString)\n Student_Number: \(studentNumberString)\n First_Name: \(firstNameString)\n Last_Name: \(lastNameString)\n Assigned_Class: \(schoolClassIdString)"
    }
    
}
