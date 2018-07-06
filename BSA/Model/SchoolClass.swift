//
//  Class.swift
//  BSA
//
//  Created by Pete Holdsworth on 02/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

struct SchoolClass {
    
    var id: String!
    var name: String!
    var students: [Student]!
    
    init (id: String, name: String, students: [Student]) {
        self.id = id
        self.name = name
        self.students = students
    }
    
}
