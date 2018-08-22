//
//  RAGAssessment.swift
//  BSA
//
//  Created by Pete Holdsworth on 22/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

class RAGAssessment {
    
    // Properties:
    var id : String!
    var date: Date!
    var period: String!
    var studentNumber: Int!
    var assessment: String!
    
     // Custom initialiser
    init(id: String, date: Date, period: String, studentNumber: Int, assessment: String) {
        self.id = id
        self.date = date
        self.period = period
        self.studentNumber = studentNumber
        self.assessment = assessment
    }
    
}
