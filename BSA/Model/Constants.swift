//
//  Constants.swift
//  BSA
//
//  Created by Pete Holdsworth on 13/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class Constants {
    
    
    /// Data values:
    static let LOGGED_IN_ACCOUNT_ID = "loggedInAccountID"
    static let LOGGED_IN_ACCOUNT_NAME = "loggedInAccountName"
    static let LOGGED_IN_ACCOUNT_SECURITY_LEVEL = "loggedInAccountSecurityLevel"
    static let LOGGED_IN_ACCOUNT_CLASS_ID = "loggedInAccountClassNumber"
    
    static let BEHAVIOURS = (kicking: "kicking", headbutt: "headbutt", hitting: "hitting", biting: "biting", slapping: "slapping", scratching: "scratching", clothesGrabbing: "clothesGrabbing", hairPulling: "hairPulling")
    static let PURPOSES = (socialAttention: "socialAttention", tangibles: "tangibles", escape: "escape", sensory: "sensory", health: "health", activityAvoidance: "activityAvoidance", unknown: "unknown")
    static let RESTRAINTS = (nonRPI: "nonRPI", unplannedRPI: "unplannedRPI", RPI: "RPI")
    static let RAG_STATUSES = (red: "red", amber: "amber", green: "green", na: "na", none: "none")
    static let SCHOOL_DAY_PERIODS = (p1: "p1", p2: "p2", p3: "p3", l1: "l1", l2: "l2", p4: "p4", p5: "p5", p6: "p6", p7: "p7")
    
    // Returns a unique value - for database id's
    static func getUniqueId() -> String {
        return NSUUID().uuidString
    }
    
    
    /// Animation values:
    static let ANIMATION_DELAY = 0
    static let SPRING_BOUNCINESS: CGFloat = 0
    static let SPRING_SPEED: CGFloat = 12
    static let REPORT_ANIMATION_DELAY = 0.2
    static let REPORT_ANIMATION_SPEED = 1.0
    static let ADMIN_RAGSANDINCIDENTS_REPORT_ANIMATION_SPEED = 0.6
    static let RAG_SELECTION_SPEED = 0.1
    
    
    /// Color scheme values:
    static let RAG_SCREEN_COLOR = UIColor(red: 103/255, green: 142/255, blue: 166/255, alpha: 1.0)
    static let INCIDENTS_SCREEN_COLOR = UIColor(red: 149/255, green: 120/255, blue: 165/255, alpha: 1.0)
    static let CLASS_REPORTS_SCREEN_COLOR = UIColor(red: 70/255, green: 181/255, blue: 151/255, alpha: 1.0)
    static let PEOPLE_SCREEN_COLOR = UIColor(red: 103/255, green: 142/255, blue: 166/255, alpha: 1.0)
    static let ADMIN_REPORTS_SCREEN_COLOR = UIColor(red: 67/255, green: 174/255, blue: 146/255, alpha: 1.0)
    
    static let BLACK = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
    
    static let GRAY = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0)
    static let GRAY_DARK = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1.0)
    static let GRAY_LIGHT = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
    static let GRAY_VERY_LIGHT = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
    
    static let RED = UIColor(red: 195/255, green: 95/255, blue: 95/255, alpha: 1.0)
    static let RED_DARK = UIColor(red: 177/255, green: 55/255, blue: 55/255, alpha: 1.0)
    
    static let AMBER = UIColor(red: 255/255, green: 211/255, blue: 95/255, alpha: 1.0)
    static let AMBER_DARK = UIColor(red: 174/255, green: 137/255, blue: 39/255, alpha: 1.0)
    
    static let GREEN = UIColor(red: 124/255, green: 227/255, blue: 128/255, alpha: 1.0)
    static let GREEN_DARK = UIColor(red: 56/255, green: 145/255, blue: 59/255, alpha: 1.0)
    
    static let BLUE = UIColor(red: 69/255, green: 165/255, blue: 207/255, alpha: 1.0)
    
    static let PURPLE = UIColor(red: 196/255, green: 111/255, blue: 251/255, alpha: 1.0)
    static let PURPLE_DARK = UIColor(red: 120/255, green: 47/255, blue: 167/255, alpha: 1.0)
    

    // Font values:
    static let CHART_AXIS_LABEL_FONT = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let CHART_VALUE_LABEL_FONT = UIFont.systemFont(ofSize: 13, weight: .regular)
    
    /// Time values:
    
        // end of period 1
    static let P1_END_HOURS = 10
    static let P1_END_MINS = 0
    
        // end of period 2
    static let P2_END_HOURS = 11
    static let P2_END_MINS = 0
    
        // end of period 3
    static let P3_END_HOURS = 12
    static let P3_END_MINS = 0
    
        // end of lunch 1
    static let L1_END_HOURS = 12
    static let L1_END_MINS = 30
    
        // end of lunch 2
    static let L2_END_HOURS = 13
    static let L2_END_MINS = 0
    
        // end of period 4
    static let P4_END_HOURS = 14
    static let P4_END_MINS = 0
    
        // end of period 5
    static let P5_END_HOURS = 15
    static let P5_END_MINS = 0
    
        // end of period 6
    static let P6_END_HOURS = 16
    static let P6_END_MINS = 0
    
        // end of period 7
    static let P7_END_HOURS = 17
    static let P7_END_MINS = 0
    
        // number of hours after a perid has ended before a period's completion status is shown as 'Not Complete':
    static let LATE_COMPLETION_HOURS = 1
    
    
    
    static let TODAY_START_TIME = Date().dateAt(hours: 0, minutes: 0)
    static let THIS_TERM_START_TIME = Date().dateFor(day: 9, month: 4, year: 2018)!
    static let LAST_TERM_START_TIME = Date().dateFor(day: 8, month: 1, year: 2018)!
    static let LAST_TERM_END_TIME = Date().dateFor(day: 30, month: 3, year: 2018)!
    static let THIS_YEAR_START_TIME = Date().dateFor(day: 4, month: 9, year: 2017)!
    static let LAST_YEAR_START_TIME = Date().dateFor(day: 5, month: 9, year: 2016)!
    static let LAST_YEAR_END_TIME = Date().dateFor(day: 21, month: 7, year: 2017)!
    static let ALL_TIME_START_TIME = Date().dateFor(day: 1, month: 1, year: 2000)!
    

    /// Firebase Database values:
    static let FIREBASE_USER_ACCOUNTS = "user_accounts"
    static let FIREBASE_USER_ACCOUNT_NAME = "account_name"
    static let FIREBASE_USER_ACCOUNT_SECURITY_LEVEL = "account_security_level"
    static let FIREBASE_USER_ACCOUNT_CLASS_ID = "account_class_Id"
    static let FIREBASE_USER_ACCOUNT_PASSWORD = "account_password"
    
    static let FIREBASE_SCHOOL_CLASSES = "school_classes"
    static let FIREBASE_SCHOOL_CLASS_NAME = "class_name"
    
    static let FIREBASE_STAFF = "staff_members"
    static let FIREBASE_STAFF_NUMBER = "staff_number"
    static let FIREBASE_STAFF_FIRST_NAME = "staff_first_name"
    static let FIREBASE_STAFF_LAST_NAME = "staff_last_name"
    
    static let FIREBASE_STUDENTS = "students"
    static let FIREBASE_STUDENT_NUMBER = "student_number"
    static let FIREBASE_STUDENT_FIRST_NAME = "student_first_name"
    static let FIREBASE_STUDENT_LAST_NAME = "student_last_name"
    static let FIREBASE_STUDENT_CLASS_ID = "student_class_id"
    
    static let FIREBASE_INCIDENTS = "incidents"
    static let FIREBASE_INCIDENT_DATE = "incident_date"
    static let FIREBASE_INCIDENT_DURATION = "incident_duration"
    static let FIREBASE_INCIDENT_STUDENT = "incident_student"
    static let FIREBASE_INCIDENT_BEHAVIOURS = "incident_behaviours"
    static let FIREBASE_INCIDENT_INTENSITY = "incident_intensity"
    static let FIREBASE_INCIDENT_STAFF = "incident_staff"
    static let FIREBASE_INCIDENT_ACCIDENT_FORM = "incident_accident_form"
    static let FIREBASE_INCIDENT_RESTRAINT = "incident_restraint"
    static let FIREBASE_INCIDENT_ALARM_PRESSED = "incident_alarm_pressed"
    static let FIREBASE_INCIDENT_PURPOSES = "incident_purposes"
    static let FIREBASE_INCIDENT_NOTES = "incident_notes"
    
    static let FIREBASE_RAG_ASSESSMENTS = "rag_assessments"
    static let FIREBASE_RAG_ASSESSMENT_DATE = "rag_assessment_date"
    static let FIREBASE_RAG_ASSESSMENT_PERIOD = "rag_assessment_period"
    static let FIREBASE_RAG_ASSESSMENT_STUDENT = "rag_assessment_student"
    static let FIREBASE_RAG_ASSESSMENT_STATUS = "rag_assessment_status"
    
}
