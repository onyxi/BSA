//
//  Incident.swift
//  BSA
//
//  Created by Pete Holdsworth on 01/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

class Incident: Equatable {
//: CustomStringConvertible, Equatable {

    // Properties:
    let id: String!
//    let incidentNumber: Int!
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
//         incidentNumber: Int, dateTime: Date, duration: Int, student: Student, behaviours: [Behaviour], intensity: Float, staff: [Staff], accidentFormCompleted: Bool, restraint: Restraint, alarmPressed: Bool, purposes: [Purpose], notes: String) {
        self.id = id
//        self.incidentNumber = incidentNumber
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

    // Provides custom representation for printing of instances - in more readable format
//    var description: String {
//        let dateTimeString = "Date & Time: \(dateTime!)"
//        let durationString = "Duration: \(duration!)"
//        let studentString = "Student: \(student!.firstName!) \(student!.lastName!)"
//        var behavioursString = "Behaviors: "
//        for i in 1...behaviours!.count {
//            if i < behaviours!.count {
//                behavioursString.append("\(behaviours![i-1].type!), ")
//            } else {
//                behavioursString.append("\(behaviours![i-1].type!)")
//            }
//        }
//        let intensityString = "Intensity: \(intensity!)"
//        var staffString = "Staff: "
//        for i in 1...staff!.count {
//            if i < staff!.count {
//                staffString.append("\(staff![i-1].firstName!) \(staff![i-1].lastName!), ")
//            } else {
//                staffString.append("\(staff![i-1].firstName!) \(staff![i-1].lastName!)")
//            }
//        }
//        var accidentFormString = "Accident Form Completed: "
//        if accidentFormCompleted {
//            accidentFormString.append("Yes")
//        } else {
//            accidentFormString.append("No")
//        }
//        let restraintString = "Restraint: \(restraint)"
//        var alarmPressedString = "Alarm Pressed: "
//        if alarmPressed {
//            alarmPressedString.append("Yes")
//        } else {
//            alarmPressedString.append("No")
//        }
//        var purposesString = "Purposes: "
//        for i in 1...purposes!.count {
//            if i < purposes!.count {
//                purposesString.append("\(purposes![i-1].type!), ")
//            } else {
//                purposesString.append("\(purposes![i-1].type!)")
//            }
//        }
//        let notesString = "Notes: \(notes!)"
//
//        return "Incident details: \n \(dateTimeString) \n\(durationString) \n\(studentString) \n\(behavioursString) \n\(intensityString) \n\(staffString) \n\(accidentFormString) \n\(restraintString) \n\(alarmPressedString) \n\(purposesString) \n\(notesString)"
//    }
    
    // Conform to 'Equatable' protocol by comparing instances on their unique 'id' attribute
    static func == (lhs: Incident, rhs: Incident) -> Bool {
        return lhs.id == rhs.id
    }
    
}

// Provide constrained values for different available incident-restraint types
//enum Restraint {
//    case RPI
//    case nonRPI
//    case unplannedRPI
//}
