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
//    var classNumber: Int!
    var className: String!
//    var classStudents: [Int]?
    
    // Custom initialiser
    init (id: String, className: String) {
//          classNumber: Int, className: String) {
//          classStudents: [Int]?) {
//          classNumber: Int, className: String, classStudents: [Int]?) {
        self.id = id
//        self.classNumber = classNumber
        self.className = className
//        self.classStudents = classStudents
    }
    
    
    // Conform to 'Equatable' protocol by comparing instances on their unique 'id' attribute
    static func == (lhs: SchoolClass, rhs: SchoolClass) -> Bool {
//        return lhs.classNumber == rhs.classNumber
        return lhs.id == rhs.id
    }
    
    // Provides custom representation for printing of instances - in more readable format
    var description: String {
        let idString = String(describing: id)
//        let classNumberString = String(describing: classNumber!)
        let classNameString = String(describing: className!)
//        let classStudentsString = String(describing: classStudents)
        
//        return "School Class object:\n Database_id: \(idString)\n Class_Number: \(classNumberString)\n Class_Name: \(classNameString)\n Class_Students: \(classStudentsString)"
//        return "School Class object:\n Database_id: \(idString)\n Class_Name: \(classNameString)\n Class_Students: \(classStudentsString)"
        return "School Class object:\n Database_id: \(idString)\n Class_Name: \(classNameString)"
//        Class_Number: \(classNumberString)\n Class_Name: \(classNameString)"
    }
    
}
