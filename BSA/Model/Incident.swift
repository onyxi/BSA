//
//  Incident.swift
//  BSA
//
//  Created by Pete Holdsworth on 01/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

class Incident: CustomStringConvertible {
    
    var id: String!
    
    var dateTime: Date?
    var duration: Int?
    var student: Student?
    var behaviours: [Behaviour]?
    var intensity: Float?
    var staff: [Staff]?
    var accidentFormCompleted: Bool
    var restraint: Restraint
    var alarmPressed: Bool
    var purposes: [Purpose]?
    var notes: String?
    
    init(id: String, dateTime: Date, duration: Int, student: Student, behaviours: [Behaviour], intensity: Float, staff: [Staff], accidentFormCompleted: Bool, restraint: Restraint, alarmPressed: Bool, purposes: [Purpose], notes: String) {
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

    var description: String {
        let dateTimeString = dateTime != nil ? "Date & Time: \(dateTime!)" : "Date & Time: unknown"
        let durationString = duration != nil ? "Duration: \(duration!)" : "Duration: unknown"
        var studentString = student != nil ? "Student: \(student!.firstName!) \(student!.lastName!)" : "Student: unknown"
        var behavioursString = "Behaviors: "
        if behaviours != nil {
            for i in 1...behaviours!.count {
                if i < behaviours!.count {
                    behavioursString.append("\(behaviours![i-1].type!), ")
                } else {
                    behavioursString.append("\(behaviours![i-1].type!)")
                }
            }
        } else {
            behavioursString.append("unknown")
        }
        var intensityString = intensity != nil ? "Intensity: \(intensity!)" : "Intensity: unknown"
        var staffString = "Staff: "
        if staff != nil {
            for i in 1...staff!.count {
                if i < staff!.count {
                    staffString.append("\(staff![i-1].firstName!) \(staff![i-1].lastName!), ")
                } else {
                    staffString.append("\(staff![i-1].firstName!) \(staff![i-1].lastName!)")
                }
            }
        } else {
            staffString.append("unknown")
        }
        var accidentFormString = "Accident Form Completed: "
        if accidentFormCompleted {
            accidentFormString.append("Yes")
        } else {
            accidentFormString.append("No")
        }
        let restraintString = "Restraint: \(restraint)"
        var alarmPressedString = "Alarm Pressed: "
        if alarmPressed {
            alarmPressedString.append("Yes")
        } else {
            alarmPressedString.append("No")
        }
        var purposesString = "Purposes: "
        if purposes != nil {
            for i in 1...purposes!.count {
                if i < purposes!.count {
                    purposesString.append("\(purposes![i-1].type!), ")
                } else {
                    purposesString.append("\(purposes![i-1].type!)")
                }
            }
        } else {
            purposesString.append("unknown")
        }
        var notesString = "Notes: \(notes!)"
        
        return "Incident details: \n \(dateTimeString) \n\(durationString) \n\(studentString) \n\(behavioursString) \n\(intensityString) \n\(staffString) \n\(accidentFormString) \n\(restraintString) \n\(alarmPressedString) \n\(purposesString) \n\(notesString)"
    }
    
}

enum Restraint {
    case RPI
    case nonRPI
    case unplannedRPI
}
