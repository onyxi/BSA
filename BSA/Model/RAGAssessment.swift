//
//  RAGAssessment.swift
//  BSA
//
//  Created by Pete Holdsworth on 22/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

class RAGAssessment {
    
    var id : String!
    var date: Date!
    var period: SchoolDayPeriod!
    var studentNumber: Int!
    var assessment: RAGStatus!
    
    init(id: String, date: Date, period: SchoolDayPeriod, studentNumber: Int, assessment: RAGStatus) {
        self.id = id
        self.date = date
        self.period = period
        self.studentNumber = studentNumber
        self.assessment = assessment
    }
    
}


// Provide constrained values for different available Selection/Indicator positions
enum RAGStatus {
    case green
    case amber
    case red
    case na
    case none
}

// Provide constrained values for different available school-day periods
enum SchoolDayPeriod {
    case p1
    case p2
    case p3
    case p4
    case p5
    case p6
    case p7
}
