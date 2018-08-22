//
//  Incident.swift
//  BSA
//
//  Created by Pete Holdsworth on 01/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

class Incident: Equatable {

    // Properties:
    let id: String!
    var dateTime: Date!
    var duration: Int!
    var student: Int!
    var behaviours: [String]!
    var intensity: Float!
    var staff: [Int]!
    var accidentFormCompleted: Bool!
    var restraint: String!
    var alarmPressed: Bool!
    var purposes: [String]!
    var notes: String!
    
    // Custom initialiser
    init(id: String, dateTime: Date, duration: Int, student: Int, behaviours: [String], intensity: Float, staff: [Int], accidentFormCompleted: Bool, restraint: String, alarmPressed: Bool, purposes: [String], notes: String) {
        self.id = id
        self.dateTime = dateTime
        self.duration = duration
        self.student = student
        self.behaviours = behaviours
        self.intensity = intensity
        self.staff = staff
        self.accidentFormCompleted = accidentFormCompleted
        self.restraint = restraint
        self.alarmPressed = alarmPressed
        self.purposes = purposes
        self.notes = notes
    }
    
    // Conform to 'Equatable' protocol by comparing instances on their unique 'id' attribute
    static func == (lhs: Incident, rhs: Incident) -> Bool {
        return lhs.id == rhs.id
    }
    
}
