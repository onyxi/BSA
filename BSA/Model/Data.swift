//
//  Data.swift
//  BSA
//
//  Created by Pete Holdsworth on 13/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase



enum FirebaseError: Error {
    case runtimeError(String)
}





class Data {
//    private static let _instance = Data()
//
//    static var instance: Data {
//        return _instance
//    }
//    
//    var mainRef: DatabaseReference = Database.database().reference()
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    static func saveSchoolClass(id: String?, classNumber: Int, className: String!, classStudents: [Int]?) {
//        
////
//        
//        // retrieve school class data from Firebase
//        let queryRef = instance.mainRef.child(Constants.FIREBASE_SCHOOL_CLASSES)
//        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//                guard !snapshots.isEmpty else {
//                    // no user accounts returned
//                    print ("error getting user acconts when trying to save class object")
//                    return
//                }
//                
//                var classNumbers = [Int]()
//                
//                for snap in snapshots {
//                    let storedClassNumber = snap.childSnapshot(forPath: Constants.FIREBASE_SCHOOL_CLASS_NUMBER).value as! String
//                    classNumbers.append(Int(storedClassNumber)!)
//                }
//                
//                let classNumberToSave = classNumbers.max()! + 1
//                
//                var studentNumbers = Dictionary<String, AnyObject>()
//                if classStudents != nil {
//                    for studentNumber in classStudents! {
//                        studentNumbers[NSUUID().uuidString] = studentNumber as AnyObject
//                    }
//                }
//                
//                let schoolClassUploadObject: Dictionary<String, AnyObject> = [
//                    Constants.FIREBASE_SCHOOL_CLASS_NUMBER : String(classNumberToSave) as AnyObject,
//                    Constants.FIREBASE_SCHOOL_CLASS_NAME : className as AnyObject,
//                    Constants.FIREBASE_SCHOOL_CLASS_STUDENTS : String(1) as AnyObject,
//                    Constants.FIREBASE_SCHOOL_CLASS_STUDENTS : studentNumbers as AnyObject
//                ]
//                
//                let classID = id != nil ? id : NSUUID().uuidString
////                instance.mainRef.child(Constants.FIREBASE_USER_ACCOUNTS).child(accountID!)
//                instance.mainRef.child(Constants.FIREBASE_SCHOOL_CLASSES).child(classID!).updateChildValues(schoolClassUploadObject, withCompletionBlock: { (error, ref) in
//                    if let error = error { // upload error occurred - provide feedback
//                        print (error.localizedDescription)
//                    } else { // callback once media upload complete
////                        self.commitMediaDelegate?.didCommitMedia()
//                    }
//                    
//                })
//                    
////                    .setValue(accountUploadObject as AnyObject) { (error, ref) -> Void in
////                    if error != nil {
////                        print ("ERROR: \(error)")
////
////                    } else {
////                        print ("Success saving User Account!")
////
////                    }
////                }
//            }
//        })
//        
//        
//        
//    }
//    
//
//    static func saveUserAccount(id: String?, accountNumber: Int?, name: String, schoolClassNumber: Int?) throws -> Bool {
//        
//        //        let account = UserAccount(id: nil, accountNumber: 1, accountName: "Admin", securityLevel: 0, schoolClassNumber: nil)
//            // retrieve user account data from Firebase
//        let queryRef = instance.mainRef.child(Constants.FIREBASE_USER_ACCOUNTS)
//        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//                
//                guard !snapshots.isEmpty else {
//                    // no user accounts returned
//                    throw FirebaseError.runtimeError("Error getting existing User Acconts before trying to save User Account")
//                    return
//                }
//                
//                var fetchedUserAccounts = [UserAccount]()
//                
//                for snap in snapshots {
//                    let storedAccountID = snap.key
//                    let storedAccountNumber = snap.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNTS_NUMBER).value as! String
//                    let storedAccountName = snap.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNTS_NAME).value as! String
//                    let storedSecurityLevel = snap.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNTS_SECURITY_LEVEL).value as! String
//                    let storedSchoolClassNumber = snap.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNTS_CLASS_NUMBER).value as! String
//                    
//                    let fetchedUserAccount = UserAccount(
//                        id: storedAccountID,
//                        accountNumber: Int(storedAccountNumber)!,
//                        accountName: storedAccountName,
//                        securityLevel: Int(storedSecurityLevel)!,
//                        schoolClassNumber: Int(storedSchoolClassNumber))
//                    fetchedUserAccounts.append(fetchedUserAccount)
//                }
//                
//                var accountNumbers = [Int]()
//                for account in fetchedUserAccounts {
//                    accountNumbers.append(account.accountNumber)
//                }
//                
//                let accountNumberToSave = accountNumbers.max()! + 1
//                
//                
//                let accountUploadObject: Dictionary<String, AnyObject> = [
//                    Constants.FIREBASE_USER_ACCOUNTS_NUMBER : String(accountNumberToSave) as AnyObject,
//                    Constants.FIREBASE_USER_ACCOUNTS_NAME : name as AnyObject,
//                    Constants.FIREBASE_USER_ACCOUNTS_SECURITY_LEVEL : String(1) as AnyObject,
//                    Constants.FIREBASE_USER_ACCOUNTS_CLASS_NUMBER : schoolClassNumber != nil ? String(schoolClassNumber!) as AnyObject : "" as AnyObject
//                ]
//                
//                let accountID = id == nil ? NSUUID().uuidString : id
//                
//                instance.mainRef.child(Constants.FIREBASE_USER_ACCOUNTS).child(accountID!).setValue(accountUploadObject as AnyObject) { (error, ref) -> Void in
//                    if error != nil {
//                        print ("ERROR: \(error)")
//                        throw FirebaseError.runtimeError("Unable to save User Account")
//                    } else {
//                        print ("Success saving User Account!")
//                        return true
//                    }
//                }
//                
//            }
//        })
//        return false
//    }
//
//    
//    // Returns all User Account objects retrieved from storage
//    static func getAllUserAccounts () -> [UserAccount]? {
//        return DBSeed.userAccounts
//    
//    
//    }
//    
//    
//    
//    // Returns a particular User Account object retreived from storage
//    static func getAccount(numbered accountNumber: Int) -> UserAccount? {
//        
//            // search for User Account - and return if found
//        for account in DBSeed.userAccounts {
//            if account.accountNumber == accountNumber {
//                return account
//            }
//        }
//            // if not found return nil
//        return nil
//    }
//    
//    
//    // Returns all School Class objects retrieved from storage
//    static func getAllSchoolClasses () -> [SchoolClass]? {
//        return DBSeed.schoolClasses
//    }
//    
//    // Returns a particular School Class object retreived from storage
//    static func getSchoolClass(numbered schoolClassNumber: Int?) -> SchoolClass? {
//        
//            // search for School Class - and return if found
//        for schoolClass in DBSeed.schoolClasses {
//            if schoolClass.classNumber == schoolClassNumber {
//                return schoolClass
//            }
//        }
//            // if not found return nil
//        return nil
//    }
//    
//    // Returns all staff member objects retrieved from storage
//    static func getAllStaffMembers() -> [Staff]? {
//        return DBSeed.staffMembers
//    }
//    
//    // Returns a particular Staff Member object retreived from storage
//    static func getStaffMember(numbered staffNumber: Int) -> Staff? {
//        
//            // search for Staff Member - and return if found
//        for staffMember in DBSeed.staffMembers {
//            if staffMember.staffNumber == staffNumber {
//                return staffMember
//            }
//        }
//            // if not found return nil
//        return nil
//    }
//    
//    // Returns all student objects retrieved from storage
//    static func getAllStudents() -> [Student]? {
//        return DBSeed.students
//    }
//    
//    // Returns a particular Student object retreived from storage
//    static func getStudent(numbered studentNumber: Int) -> Student? {
//            // search for Student - return if found
//        for student in DBSeed.students {
//            if student.studentNumber == studentNumber {
//                return student
//            }
//        }
//            // if not found return nil
//        return nil
//    }
//    
//    // Returns all the Students associated with a given School Class
//    static func getStudents(for schoolClass: SchoolClass) -> [Student]? {
//        var schoolClassStudents = [Student]()
//        guard let students = getAllStudents() else {
//            print ("error getting students")
//            return nil
//        }
//        
//        for student in students {
//            if student.schoolClassNumber == schoolClass.classNumber {
//                schoolClassStudents.append(student)
//            }
//        }
//        return schoolClassStudents
//    }
//    
//    
//    // Returns all School Classes along with all the Students associated with each one
//    static func getAllClassesWithStudents() -> [(SchoolClass, [Student])]? {
//        
//        var schoolClassesWithStudentsToReturn = [(SchoolClass, [Student])]()
//        
//        guard let schoolClasses = getAllSchoolClasses() else {
//            print("error getting school classes")
//            return nil
//        }
//        
//        for schoolClass in schoolClasses {
//            if let classStudents = getStudents(for: schoolClass) {
//                schoolClassesWithStudentsToReturn.append((schoolClass, classStudents))
//            } else {
//                print ("error getting classStudents")
//            }
//        }
//        
//        if schoolClassesWithStudentsToReturn.isEmpty {
//            return nil
//        } else {
//            return schoolClassesWithStudentsToReturn
//        }
//    }
//    
//    // Returns all behaviour objects retrieved from storage
//    static func getAllBehaviours() -> [Behaviour]? {
//        return DBSeed.behaviours
//    }
//    
//    // Returns all purpose objects retreieved from storage
//    static func getAllPurposes() -> [Purpose]? {
//        return DBSeed.purposes
//    }
//    
////    // Returns RAG period statuses
////    static func getDays() -> [DayRAGs] {
////        return [
////            DayRAGs(p1: 1, p2: 1, p3: 1, p4: nil, p5: 1, p6: nil, p7: nil),
////            DayRAGs(p1: 1, p2: 1, p3: 1, p4: nil, p5: 1, p6: 1, p7: nil),
////            DayRAGs(p1: 1, p2: 1, p3: nil, p4: 1, p5: 1, p6: 1, p7: 1),
////            DayRAGs(p1: 1, p2: 1, p3: 1, p4: 1, p5: 1, p6: 1, p7: 1),
////            DayRAGs(p1: 1, p2: 1, p3: 1, p4: 1, p5: 1, p6: 1, p7: 1),
////            DayRAGs(p1: 1, p2: 1, p3: 1, p4: 1, p5: 1, p6: 1, p7: 1),
////            DayRAGs(p1: 1, p2: 1, p3: 1, p4: 1, p5: 1, p6: 1, p7: 1)
////        ]
////    }
//    
//    
//    // Returns from storage all report data for a given School-Class recorded in a given time period
//    static func getClassReportData(for schoolClass: SchoolClass, from timePeriod: TimePeriod) -> ClassReportDataSet? {
//       
//        guard let students = getStudents(for: schoolClass) else {
//            // problem getting class students
//            print ("error getting school-class students")
//            return nil
//        }
//        
//        guard let ragAssessments = getRAGAssessments(for: students, fromTimePeriod: timePeriod) else {
//            print ("error getting rag assessments for class report")
//            return nil
//        }
//        
//        guard let incidents = getIncidents(for: students, fromTimePeriod: timePeriod) else {
//            print("error getting incidents for class report")
//            return nil
//        }
//        
//        var redsCount = 0
//        var ambersCount = 0
//        var greensCount = 0
//        
//        var incidentsCount = incidents.count
//        var totalIntensity: Float = 0.0
//        var schoolDayPeriodsCount = 0
//        
//        for rag in ragAssessments {
//            switch rag.assessment {
//            case .red:
//                redsCount += 1
//            case .amber:
//                ambersCount += 1
//            case .green:
//                    greensCount += 1
//            default: break
//            }
//        }
//        
//        
//        
//        switch timePeriod {
//        case .today:
//            schoolDayPeriodsCount = getNumberOfPeriodsAlreadyPastToday()
//        case .currentWeek:
//            switch getDayString(for: Date()) {
//            case "Monday":
//                schoolDayPeriodsCount = getNumberOfPeriodsAlreadyPastToday()
//            case "Tuesday":
//                schoolDayPeriodsCount = getNumberOfPeriodsAlreadyPastToday() + 7
//            case "Wednesday":
//                schoolDayPeriodsCount = getNumberOfPeriodsAlreadyPastToday() + 14
//            case "Thursday":
//                schoolDayPeriodsCount = getNumberOfPeriodsAlreadyPastToday() + 21
//            case "Friday":
//                schoolDayPeriodsCount = getNumberOfPeriodsAlreadyPastToday() + 28
//            case "Saturday":
//                schoolDayPeriodsCount = getNumberOfPeriodsAlreadyPastToday() + 35
//            case "Sunday":
//                schoolDayPeriodsCount = getNumberOfPeriodsAlreadyPastToday() + 42
//            default: break
//            }
//        case .lastWeek:
//            schoolDayPeriodsCount = 49
//        case .thisTerm:
//            schoolDayPeriodsCount = 588
//        case .lastTerm:
//            schoolDayPeriodsCount = 588
//        case .thisYear:
//            schoolDayPeriodsCount = 1365
//        case .lastYear:
//            schoolDayPeriodsCount = 1400
//        case .allTime:
//            schoolDayPeriodsCount = 2800
//        }
//        
//        for incident in incidents {
//            totalIntensity += incident.intensity!
//        }
//        
//        let ragsTotal = redsCount + ambersCount + greensCount
//        let redsPercentage: Double = ragsTotal == 0 ? 0.0 : round((Double(redsCount) / Double(ragsTotal) * 100) * 10) / 10
//        let ambersPercentage: Double = ragsTotal == 0 ? 0.0 : round((Double(ambersCount) / Double(ragsTotal) * 100) * 10) / 10
//        let greensPercentage: Double = ragsTotal == 0 ? 0.0 : round((Double(greensCount) / Double(ragsTotal) * 100) * 10) / 10
//        
//        let averageIntensity: Float = incidentsCount == 0 ? 0.0 : Float(totalIntensity) / Float(incidentsCount)
//        
//        let incidentLikelihood: Double = schoolDayPeriodsCount == 0 ? 0.0 : round((Double(incidentsCount) / Double(schoolDayPeriodsCount) * 100) * 10) / 10
//        print(incidentsCount)
//        print(schoolDayPeriodsCount)
//        return ClassReportDataSet(entityName: schoolClass.className, timePeriod: timePeriod, aveReds: redsPercentage, aveAmbers: ambersPercentage, aveGreens: greensPercentage, aveIntensity: averageIntensity, incidentLikelihood: incidentLikelihood)
//        
////        // for testing...
////        switch timePeriod {
////        case .lastWeek:
////            return ClassReportDataSet(entityName: "Class C", timePeriod: timePeriod, aveReds: 3.2, aveAmbers: 5.7, aveGreens: 91.1, aveIntensity: 0.73, incidentLikelihood: 12.7)
////        default:
////            return ClassReportDataSet(entityName: "Class C", timePeriod: timePeriod, aveReds: 2.7, aveAmbers: 4.5, aveGreens: 92.8, aveIntensity: 0.59, incidentLikelihood: 11.3)
////        }
//    }
//    
//    
//    
//    static func getNumberOfPeriodsAlreadyPastToday() -> Int {
//        
//        var schoolDayPeriodsCount = 0
//        
//        if Date() > Date().dateAt(hours: Constants.P1_END_HOURS, minutes: Constants.P1_END_MINS) && Date() < Date().dateAt(hours: Constants.P2_END_HOURS, minutes: Constants.P2_END_MINS) {
//            schoolDayPeriodsCount = 1
//        } else if Date() >= Date().dateAt(hours: Constants.P2_END_HOURS, minutes: Constants.P2_END_MINS) && Date() < Date().dateAt(hours: Constants.P3_END_HOURS, minutes: Constants.P3_END_MINS) {
//            schoolDayPeriodsCount = 2
//        } else if Date() >= Date().dateAt(hours: Constants.P3_END_HOURS, minutes: Constants.P3_END_MINS) && Date() < Date().dateAt(hours: Constants.L1_END_HOURS, minutes: Constants.L1_END_MINS) {
//            schoolDayPeriodsCount = 3
//        } else if Date() >= Date().dateAt(hours: Constants.L1_END_HOURS, minutes: Constants.L1_END_MINS) && Date() < Date().dateAt(hours: Constants.L2_END_HOURS, minutes: Constants.L2_END_MINS) {
//            schoolDayPeriodsCount = 4
//        } else if Date() >= Date().dateAt(hours: Constants.L2_END_HOURS, minutes: Constants.L2_END_MINS) && Date() < Date().dateAt(hours: Constants.P4_END_HOURS, minutes: Constants.P4_END_MINS) {
//            schoolDayPeriodsCount = 5
//        } else if Date() >= Date().dateAt(hours: Constants.P4_END_HOURS, minutes: Constants.P4_END_MINS) && Date() < Date().dateAt(hours: Constants.P5_END_HOURS, minutes: Constants.P5_END_MINS) {
//            schoolDayPeriodsCount = 6
//        } else if Date() >= Date().dateAt(hours: Constants.P5_END_HOURS, minutes: Constants.P5_END_MINS) && Date() < Date().dateAt(hours: Constants.P6_END_HOURS, minutes: Constants.P6_END_MINS) {
//            schoolDayPeriodsCount = 7
//        } else if Date() >= Date().dateAt(hours: Constants.P6_END_HOURS, minutes: Constants.P6_END_MINS) && Date() < Date().dateAt(hours: Constants.P7_END_HOURS, minutes: Constants.P7_END_MINS) {
//            schoolDayPeriodsCount = 8
//        } else if Date() >= Date().dateAt(hours: Constants.P7_END_HOURS, minutes: Constants.P7_END_MINS) {
//            schoolDayPeriodsCount = 9
//        }
//        
//        return schoolDayPeriodsCount
//    }
//
//    
//    static func getAllRAGAssessments(for students: [Student]) -> [RAGAssessment]? {
//        var rAGAssessments = [RAGAssessment]()
//        
//        var studentNumbers = [Int]()
//        for student in students {
//            studentNumbers.append(student.studentNumber)
//        }
//        
//        for rag in DBSeed.ragAssessments {
//            if studentNumbers.contains(rag.studentNumber) {
//                rAGAssessments.append(rag)
//            }
//        }
//        
//        return rAGAssessments
//    }
//    
//    
//    static func getRAGAssessments(for students: [Student], fromTimePeriod timePeriod: TimePeriod) -> [RAGAssessment]? {
//        var rAGAssessments = [RAGAssessment]()
//        
//        var studentNumbers = [Int]()
//        for student in students {
//            studentNumbers.append(student.studentNumber)
//        }
//        
//        var ragWindowStartTime: Date?
//        var ragWindowEndTime: Date?
//        
//        switch timePeriod {
//        case .today:
//            ragWindowStartTime = Constants.TODAY_START_TIME
//            ragWindowEndTime = Date()
//        case .currentWeek:
//            switch getDayString(for: Date()) {
//            case "Monday":
//                ragWindowStartTime = Date().dateAt(hours: 0, minutes: 0)
//            case "Tuesday":
//                ragWindowStartTime = Date().withOffset(dateOffset: -1).dateAt(hours: 0, minutes: 0)
//            case "Wednesday":
//                ragWindowStartTime = Date().withOffset(dateOffset: -2).dateAt(hours: 0, minutes: 0)
//            case "Thursday":
//                ragWindowStartTime = Date().withOffset(dateOffset: -3).dateAt(hours: 0, minutes: 0)
//            case "Friday":
//                ragWindowStartTime = Date().withOffset(dateOffset: -4).dateAt(hours: 0, minutes: 0)
//            case "Saturday":
//                ragWindowStartTime = Date().withOffset(dateOffset: -5).dateAt(hours: 0, minutes: 0)
//            case "Sunday":
//                ragWindowStartTime = Date().withOffset(dateOffset: -6).dateAt(hours: 0, minutes: 0)
//            default: break
//            }
//            ragWindowEndTime = Date()
//        case .lastWeek:
//            switch getDayString(for: Date()) {
//            case "Monday":
//                ragWindowStartTime = Date().withOffset(dateOffset: -7).dateAt(hours: 0, minutes: 0)
//                ragWindowEndTime = Date().dateAt(hours: 0, minutes: 0)
//            case "Tuesday":
//                ragWindowStartTime = Date().withOffset(dateOffset: -8).dateAt(hours: 0, minutes: 0)
//                ragWindowEndTime = Date().withOffset(dateOffset: -1).dateAt(hours: 0, minutes: 0)
//            case "Wednesday":
//                ragWindowStartTime = Date().withOffset(dateOffset: -9).dateAt(hours: 0, minutes: 0)
//                ragWindowEndTime = Date().withOffset(dateOffset: -2).dateAt(hours: 0, minutes: 0)
//            case "Thursday":
//                ragWindowStartTime = Date().withOffset(dateOffset: -10).dateAt(hours: 0, minutes: 0)
//                ragWindowEndTime = Date().withOffset(dateOffset: -3).dateAt(hours: 0, minutes: 0)
//            case "Friday":
//                ragWindowStartTime = Date().withOffset(dateOffset: -11).dateAt(hours: 0, minutes: 0)
//                ragWindowEndTime = Date().withOffset(dateOffset: -4).dateAt(hours: 0, minutes: 0)
//            case "Saturday":
//                ragWindowStartTime = Date().withOffset(dateOffset: -12).dateAt(hours: 0, minutes: 0)
//                ragWindowEndTime = Date().withOffset(dateOffset: -5).dateAt(hours: 0, minutes: 0)
//            case "Sunday":
//                ragWindowStartTime = Date().withOffset(dateOffset: -13).dateAt(hours: 0, minutes: 0)
//                ragWindowEndTime = Date().withOffset(dateOffset: -6).dateAt(hours: 0, minutes: 0)
//            default: break
//            }
//            
//        case .thisTerm:
//            ragWindowStartTime = Constants.THIS_TERM_START_TIME
//            ragWindowEndTime = Date()
//        case .lastTerm:
//            ragWindowStartTime = Constants.LAST_TERM_START_TIME
//            ragWindowEndTime = Constants.LAST_TERM_END_TIME
//        case .thisYear:
//            ragWindowStartTime = Constants.THIS_YEAR_START_TIME
//            ragWindowEndTime = Date()
//        case .lastYear:
//            ragWindowStartTime = Constants.LAST_YEAR_START_TIME
//            ragWindowEndTime = Constants.LAST_YEAR_END_TIME
//        case.allTime:
//            ragWindowStartTime = Constants.ALL_TIME_START_TIME
//            ragWindowEndTime = Date()
//        }
//        
//        
//        for rag in DBSeed.ragAssessments {
//            if studentNumbers.contains(rag.studentNumber), rag.date > ragWindowStartTime!, rag.date < ragWindowEndTime! {
//                rAGAssessments.append(rag)
//            }
//        }
//        
//        return rAGAssessments
//    }
//    
//    
//    
//    
//    static func getAllIncidents() -> [Incident] {
//        return DBSeed.incidents
//    }
//    
//    
//    static func getIncidents(for students: [Student]) -> [Incident]? {
//        var incidents = [Incident]()
//        
//        var studentNumbers = [Int]()
//        for student in students {
//            studentNumbers.append(student.studentNumber)
//        }
//        
//        for incident in DBSeed.incidents {
//            if studentNumbers.contains((incident.student?.studentNumber)!) {
//                incidents.append(incident)
//            }
//        }
//        return incidents
//    }
//    
//    
//    static func getIncidents(for students: [Student], fromTimePeriod timePeriod: TimePeriod) -> [Incident]? {
//        var incidents = [Incident]()
//        
//        var studentNumbers = [Int]()
//        for student in students {
//            studentNumbers.append(student.studentNumber)
//        }
//        
//        var incidentWindowStartTime: Date?
//        var incidentWindowEndTime: Date?
//        
//        switch timePeriod {
//        case .today:
//            incidentWindowStartTime = Constants.TODAY_START_TIME
//            incidentWindowEndTime = Date()
//        case .currentWeek:
//            
//            switch getDayString(for: Date()) {
//            case "Monday":
//                incidentWindowStartTime = Date().dateAt(hours: 0, minutes: 0)
//                incidentWindowEndTime = Date()
//            case "Tuesday":
//                incidentWindowStartTime = Date().withOffset(dateOffset: -1).dateAt(hours: 0, minutes: 0)
//            case "Wednesday":
//                incidentWindowStartTime = Date().withOffset(dateOffset: -2).dateAt(hours: 0, minutes: 0)
//            case "Thursday":
//                incidentWindowStartTime = Date().withOffset(dateOffset: -3).dateAt(hours: 0, minutes: 0)
//            case "Friday":
//                incidentWindowStartTime = Date().withOffset(dateOffset: -4).dateAt(hours: 0, minutes: 0)
//            case "Saturday":
//                incidentWindowStartTime = Date().withOffset(dateOffset: -5).dateAt(hours: 0, minutes: 0)
//            case "Sunday":
//                incidentWindowStartTime = Date().withOffset(dateOffset: -6).dateAt(hours: 0, minutes: 0)
//            default: break
//            }
//            incidentWindowEndTime = Date()
//            
//        case .lastWeek:
//            switch getDayString(for: Date()) {
//            case "Monday":
//                incidentWindowStartTime = Date().withOffset(dateOffset: -7).dateAt(hours: 0, minutes: 0)
//                incidentWindowEndTime = Date().dateAt(hours: 0, minutes: 0)
//            case "Tuesday":
//                incidentWindowStartTime = Date().withOffset(dateOffset: -8).dateAt(hours: 0, minutes: 0)
//                incidentWindowEndTime = Date().withOffset(dateOffset: -1).dateAt(hours: 0, minutes: 0)
//            case "Wednesday":
//                incidentWindowStartTime = Date().withOffset(dateOffset: -9).dateAt(hours: 0, minutes: 0)
//                incidentWindowEndTime = Date().withOffset(dateOffset: -2).dateAt(hours: 0, minutes: 0)
//            case "Thursday":
//                incidentWindowStartTime = Date().withOffset(dateOffset: -10).dateAt(hours: 0, minutes: 0)
//                incidentWindowEndTime = Date().withOffset(dateOffset: -3).dateAt(hours: 0, minutes: 0)
//            case "Friday":
//                incidentWindowStartTime = Date().withOffset(dateOffset: -11).dateAt(hours: 0, minutes: 0)
//                incidentWindowEndTime = Date().withOffset(dateOffset: -4).dateAt(hours: 0, minutes: 0)
//            case "Saturday":
//                incidentWindowStartTime = Date().withOffset(dateOffset: -12).dateAt(hours: 0, minutes: 0)
//                incidentWindowEndTime = Date().withOffset(dateOffset: -5).dateAt(hours: 0, minutes: 0)
//            case "Sunday":
//                incidentWindowStartTime = Date().withOffset(dateOffset: -13).dateAt(hours: 0, minutes: 0)
//                incidentWindowEndTime = Date().withOffset(dateOffset: -6).dateAt(hours: 0, minutes: 0)
//            default: break
//            }
//        case .thisTerm:
//            incidentWindowStartTime = Constants.THIS_TERM_START_TIME
//            incidentWindowEndTime = Date()
//        case .lastTerm:
//            incidentWindowStartTime = Constants.LAST_TERM_START_TIME
//            incidentWindowEndTime = Constants.LAST_TERM_END_TIME
//        case .thisYear:
//            incidentWindowStartTime = Constants.THIS_YEAR_START_TIME
//            incidentWindowEndTime = Date()
//        case .lastYear:
//            incidentWindowStartTime = Constants.LAST_YEAR_START_TIME
//            incidentWindowEndTime = Constants.LAST_YEAR_END_TIME
//        case.allTime:
//            incidentWindowStartTime = Constants.ALL_TIME_START_TIME
//            incidentWindowEndTime = Date()
//        }
//        
//        
//        for incident in DBSeed.incidents {
//            if studentNumbers.contains((incident.student?.studentNumber)!), incident.dateTime! > incidentWindowStartTime!, incident.dateTime! < incidentWindowEndTime! {
//                incidents.append(incident)
//            }
//        }
//        
//        return incidents
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    static func getTimePeriodEndDate(for timePeriod: TimePeriod) -> Date {
//    
//        switch timePeriod {
//        
//        case .today:
//            return Date()
//            
//        case .currentWeek:
//            return Date()
//            
//        case .lastWeek:
//            
//            switch getDayString(for: Date()) {
//            case "Monday":
//                return Date().dateAt(hours: 0, minutes: 0)
//            case "Tuesday":
//                return Date().withOffset(dateOffset: -1).dateAt(hours: 0, minutes: 0)
//            case "Wednesday":
//                return Date().withOffset(dateOffset: -2).dateAt(hours: 0, minutes: 0)
//            case "Thursday":
//                return Date().withOffset(dateOffset: -3).dateAt(hours: 0, minutes: 0)
//            case "Friday":
//                return Date().withOffset(dateOffset: -4).dateAt(hours: 0, minutes: 0)
//            case "Saturday":
//                return Date().withOffset(dateOffset: -5).dateAt(hours: 0, minutes: 0)
//            case "Sunday":
//                return Date().withOffset(dateOffset: -6).dateAt(hours: 0, minutes: 0)
//            default: break
//            }
//            
//        case .thisTerm:
//            return Date()
//        case .lastTerm:
//            return Constants.LAST_TERM_END_TIME
//        case .thisYear:
//            return Date()
//        case .lastYear:
//            return Constants.LAST_YEAR_END_TIME
//        case.allTime:
//            return Date()
//        }
//
//    }
//    
//    
//    
//    
//    static func getTimePeriodStartDate(for timePeriod: TimePeriod) -> Date {
//        
//        switch timePeriod {
//            
//        case .today:
//            return Constants.TODAY_START_TIME
//            
//        case .currentWeek:
//            
//            switch getDayString(for: Date()) {
//            case "Monday":
//               return Date().dateAt(hours: 0, minutes: 0)
//            case "Tuesday":
//                return Date().withOffset(dateOffset: -1).dateAt(hours: 0, minutes: 0)
//            case "Wednesday":
//                return Date().withOffset(dateOffset: -2).dateAt(hours: 0, minutes: 0)
//            case "Thursday":
//               return Date().withOffset(dateOffset: -3).dateAt(hours: 0, minutes: 0)
//            case "Friday":
//                return Date().withOffset(dateOffset: -4).dateAt(hours: 0, minutes: 0)
//            case "Saturday":
//                return Date().withOffset(dateOffset: -5).dateAt(hours: 0, minutes: 0)
//            case "Sunday":
//                return Date().withOffset(dateOffset: -6).dateAt(hours: 0, minutes: 0)
//            default: break
//            }
//            
//        case .lastWeek:
//            
//            switch getDayString(for: Date()) {
//            case "Monday":
//                return Date().withOffset(dateOffset: -7).dateAt(hours: 0, minutes: 0)
//            case "Tuesday":
//                return Date().withOffset(dateOffset: -8).dateAt(hours: 0, minutes: 0)
//            case "Wednesday":
//                return Date().withOffset(dateOffset: -9).dateAt(hours: 0, minutes: 0)
//            case "Thursday":
//                return Date().withOffset(dateOffset: -10).dateAt(hours: 0, minutes: 0)
//            case "Friday":
//                return Date().withOffset(dateOffset: -11).dateAt(hours: 0, minutes: 0)
//            case "Saturday":
//                return Date().withOffset(dateOffset: -12).dateAt(hours: 0, minutes: 0)
//            case "Sunday":
//                return Date().withOffset(dateOffset: -13).dateAt(hours: 0, minutes: 0)
//            default: break
//            }
//            
//        case .thisTerm:
//            return Constants.THIS_TERM_START_TIME
//        case .lastTerm:
//            return Constants.LAST_TERM_START_TIME
//        case .thisYear:
//            return Constants.THIS_YEAR_START_TIME
//        case .lastYear:
//            return Constants.LAST_YEAR_START_TIME
//        case.allTime:
//            return Constants.ALL_TIME_START_TIME
//        }
//        
//    }
//    
//    
//    static func getAdminReportData(for students: [Student]) -> AdminReportDataSet? {
//        
//        guard let rAGAssessments = getAllRAGAssessments(for: students) else {
//            // could not get RAG Assessments
//            print("Error getting assessments")
//            return nil
//        }
//        
//        guard let incidents = getIncidents(for: students) else {
//            // could not get Incidents
//            print("Error getting incidents")
//            return nil
//        }
//        
//    
//        var p1RedsCount = 0
//        var p2RedsCount = 0
//        var p3RedsCount = 0
//        var p4RedsCount = 0
//        var p5RedsCount = 0
//        var p6RedsCount = 0
//        var p7RedsCount = 0
//        
//        var p1AmbersCount = 0
//        var p2AmbersCount = 0
//        var p3AmbersCount = 0
//        var p4AmbersCount = 0
//        var p5AmbersCount = 0
//        var p6AmbersCount = 0
//        var p7AmbersCount = 0
//        
//        var p1GreensCount = 0
//        var p2GreensCount = 0
//        var p3GreensCount = 0
//        var p4GreensCount = 0
//        var p5GreensCount = 0
//        var p6GreensCount = 0
//        var p7GreensCount = 0
//        
//        
//        var mondayRedsCount = 0
//        var tuesdayRedsCount = 0
//        var wednesdayRedsCount = 0
//        var thursdayRedsCount = 0
//        var fridayRedsCount = 0
//        
//        var mondayAmbersCount = 0
//        var tuesdayAmbersCount = 0
//        var wednesdayAmbersCount = 0
//        var thursdayAmbersCount = 0
//        var fridayAmbersCount = 0
//        
//        var mondayGreensCount = 0
//        var tuesdayGreensCount = 0
//        var wednesdayGreensCount = 0
//        var thursdayGreensCount = 0
//        var fridayGreensCount = 0
//        
//        // ----
//        
//        var totalIncidents = 0
//        
//        var p1IncidentsCount = 0
//        var p2IncidentsCount = 0
//        var p3IncidentsCount = 0
//        var l1IncidentsCount = 0
//        var l2IncidentsCount = 0
//        var p4IncidentsCount = 0
//        var p5IncidentsCount = 0
//        var p6IncidentsCount = 0
//        var p7IncidentsCount = 0
//        
//        var mondayIncidentsCount = 0
//        var tuesdayIncidentsCount = 0
//        var wednesdayIncidentsCount = 0
//        var thursdayIncidentsCount = 0
//        var fridayIncidentsCount = 0
//        
//        var intensityTotal: Float = 0.0
//        
//        var kickingCount = 0
//        var headbuttCount = 0
//        var hittingCount = 0
//        var bitingCount = 0
//        var slappingCount = 0
//        var scratchingCount = 0
//        var clothesGrabbingCount = 0
//        var hairPullingCount = 0
//        
//        var socialAttentionCount = 0
//        var tangiblesCount = 0
//        var escapeCount = 0
//        var sensoryCount = 0
//        var healthCount = 0
//        var activityAvoidanceCount = 0
//        var unknownCount = 0
//        
//        // ----
//        
//            // iterate through each retreived 'RAG Assessment' object - associated with the group of given students - and extract data
//        for rag in rAGAssessments {
//            
//                // If RAG Assessment was marked as red..
//            switch rag.assessment {
//            case .red:
//                
//                    // increment green-rag counter for appropriate school-day period
//                switch rag.period {
//                case .p1:
//                    p1RedsCount += 1
//                case .p2:
//                    p2RedsCount += 1
//                case .p3:
//                    p3RedsCount += 1
//                case .p4:
//                    p4RedsCount += 1
//                case .p5:
//                    p5RedsCount += 1
//                case .p6:
//                    p6RedsCount += 1
//                case .p7:
//                    p7RedsCount += 1
//                default: break
//                }
//                
//                    // increment green-rag counter for appropriate day of the week
//                switch getDayString(for: rag.date) {
//                case "Monday":
//                    mondayRedsCount += 1
//                case "Tuesday":
//                    tuesdayRedsCount += 1
//                case "Wednesday":
//                    wednesdayRedsCount += 1
//                case "Thursday":
//                    thursdayRedsCount += 1
//                case "Friday":
//                    fridayRedsCount += 1
//                default: break
//                }
//                
//                // If RAG Assessment was marked as amber..
//            case .amber:
//                
//                    // increment green-rag counter for appropriate school-day period
//                switch rag.period {
//                case .p1:
//                    p1AmbersCount += 1
//                case .p2:
//                    p2AmbersCount += 1
//                case .p3:
//                    p3AmbersCount += 1
//                case .p4:
//                    p4AmbersCount += 1
//                case .p5:
//                    p5AmbersCount += 1
//                case .p6:
//                    p6AmbersCount += 1
//                case .p7:
//                    p7AmbersCount += 1
//                default: break
//                }
//               
//                    // increment green-rag counter for appropriate day of the week
//                switch getDayString(for: rag.date) {
//                case "Monday":
//                    mondayAmbersCount += 1
//                case "Tuesday":
//                    tuesdayAmbersCount += 1
//                case "Wednesday":
//                    wednesdayAmbersCount += 1
//                case "Thursday":
//                    thursdayAmbersCount += 1
//                case "Friday":
//                    fridayAmbersCount += 1
//                default: break
//                }
//                
//                // If RAG Assessment was marked as green..
//            case .green:
//                
//                    // increment green-rag counter for appropriate school-day period
//                switch rag.period {
//                case .p1:
//                    p1GreensCount += 1
//                case .p2:
//                    p2GreensCount += 1
//                case .p3:
//                    p3GreensCount += 1
//                case .p4:
//                    p4GreensCount += 1
//                case .p5:
//                    p5GreensCount += 1
//                case .p6:
//                    p6GreensCount += 1
//                case .p7:
//                    p7GreensCount += 1
//                default: break
//                }
//                
//                    // increment green-rag counter for appropriate day of the week
//                switch getDayString(for: rag.date) {
//                case "Monday":
//                    mondayGreensCount += 1
//                case "Tuesday":
//                    tuesdayGreensCount += 1
//                case "Wednesday":
//                    wednesdayGreensCount += 1
//                case "Thursday":
//                    thursdayGreensCount += 1
//                case "Friday":
//                    fridayGreensCount += 1
//                default: break
//                }
//                
//            case .na:
//                break
//            case .none:
//                break
//            default: break
//            }
//        }
//        
//        // ----
//        
//            // iterate through each retreived 'Incident' object - associated with the group of given students - and extract data
//        for incident in incidents {
//            
//                // increment running total of incident occurences
//            totalIncidents += 1
//            
//                // increment appropriate counter for incident occurrence by school-day period
//            if incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.P1_END_HOURS, minutes: Constants.P1_END_MINS) {
//                p1IncidentsCount += 1
//            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.P1_END_HOURS, minutes: Constants.P1_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.P2_END_HOURS, minutes: Constants.P2_END_MINS) {
//                p2IncidentsCount += 1
//            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.P2_END_HOURS, minutes: Constants.P2_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.P3_END_HOURS, minutes: Constants.P3_END_MINS) {
//                p3IncidentsCount += 1
//            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.P3_END_HOURS, minutes: Constants.P3_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.L1_END_HOURS, minutes: Constants.L1_END_MINS) {
//                l1IncidentsCount += 1
//            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.L1_END_HOURS, minutes: Constants.L1_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.L2_END_HOURS, minutes: Constants.L2_END_MINS) {
//                l2IncidentsCount += 1
//            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.L2_END_HOURS, minutes: Constants.L2_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.P4_END_HOURS, minutes: Constants.P4_END_MINS) {
//                p4IncidentsCount += 1
//            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.P4_END_HOURS, minutes: Constants.P4_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.P5_END_HOURS, minutes: Constants.P5_END_MINS) {
//                p5IncidentsCount += 1
//            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.P5_END_HOURS, minutes: Constants.P5_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.P6_END_HOURS, minutes: Constants.P6_END_MINS) {
//                p6IncidentsCount += 1
//            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.P6_END_HOURS, minutes: Constants.P6_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.P7_END_HOURS, minutes: Constants.P7_END_MINS) {
//                p7IncidentsCount += 1
//            }
//            
//                // increment appropriate counter for incident occurrence by day of week
//            switch getDayString(for: incident.dateTime!)  {
//            case "Monday":
//                mondayIncidentsCount += 1
//            case "Tuesday":
//                tuesdayIncidentsCount += 1
//            case "Wednesday":
//                wednesdayIncidentsCount += 1
//            case "Thursday":
//                thursdayIncidentsCount += 1
//            case "Friday":
//                fridayIncidentsCount += 1
//            default: break
//            }
//            
//                // add incident intensity to running total
//            intensityTotal += incident.intensity!
//            
//                // increment appropriate incident-behaviour counter for each occurrence in incidents
//            for behaviour in incident.behaviours! {
//                switch behaviour.behaviourNumber {
//                case 1:
//                    kickingCount += 1
//                case 2:
//                    headbuttCount += 1
//                case 3:
//                    hittingCount += 1
//                case 4:
//                    bitingCount += 1
//                case 5:
//                    slappingCount += 1
//                case 6:
//                    scratchingCount += 1
//                case 7:
//                    clothesGrabbingCount += 1
//                case 8:
//                    hairPullingCount += 1
//                default: break
//                }
//            }
//            
//                // increment appropriate incident-purpose counter for each occurrence in incidents
//            for purpose in incident.purposes! {
//                switch purpose.purposeNumber {
//                case 1:
//                    socialAttentionCount += 1
//                case 2:
//                    tangiblesCount += 1
//                case 3:
//                    escapeCount += 1
//                case 4:
//                    sensoryCount += 1
//                case 5:
//                    healthCount += 1
//                case 6:
//                    activityAvoidanceCount += 1
//                case 7:
//                    unknownCount += 1
//                default: break
//                }
//            }
//            
//        }
//        
//        // ----
//        
//            // Calculate total number of RAG assessments - by period
//        let p1Total = p1RedsCount + p1AmbersCount + p1GreensCount
//        let p2Total = p2RedsCount + p2AmbersCount + p2GreensCount
//        let p3Total = p3RedsCount + p3AmbersCount + p3GreensCount
//        let p4Total = p4RedsCount + p4AmbersCount + p4GreensCount
//        let p5Total = p5RedsCount + p5AmbersCount + p5GreensCount
//        let p6Total = p6RedsCount + p6AmbersCount + p6GreensCount
//        let p7Total = p7RedsCount + p7AmbersCount + p7GreensCount
//        
//            // Calculate percentage of 'Red' RAG assessments - by period
//        let p1RedsPercent: Double = p1Total == 0 ? 0.0 : Double(p1RedsCount)/Double(p1Total) * 100
//        let p2RedsPercent: Double = p2Total == 0 ? 0.0 : Double(p2RedsCount)/Double(p2Total) * 100
//        let p3RedsPercent: Double = p3Total == 0 ? 0.0 : Double(p3RedsCount)/Double(p3Total) * 100
//        let p4RedsPercent: Double = p4Total == 0 ? 0.0 : Double(p4RedsCount)/Double(p4Total) * 100
//        let p5RedsPercent: Double = p5Total == 0 ? 0.0 : Double(p5RedsCount)/Double(p5Total) * 100
//        let p6RedsPercent: Double = p6Total == 0 ? 0.0 : Double(p6RedsCount)/Double(p6Total) * 100
//        let p7RedsPercent: Double = p7Total == 0 ? 0.0 : Double(p7RedsCount)/Double(p7Total) * 100
//        
//            // Calculate percentage of 'Amber' RAG assessments - by period
//        let p1AmbersPercent: Double = p1Total == 0 ? 0.0 : Double(p1AmbersCount)/Double(p1Total) * 100
//        let p2AmbersPercent: Double = p2Total == 0 ? 0.0 : Double(p2AmbersCount)/Double(p2Total) * 100
//        let p3AmbersPercent: Double = p3Total == 0 ? 0.0 : Double(p3AmbersCount)/Double(p3Total) * 100
//        let p4AmbersPercent: Double = p4Total == 0 ? 0.0 : Double(p4AmbersCount)/Double(p4Total) * 100
//        let p5AmbersPercent: Double = p5Total == 0 ? 0.0 : Double(p5AmbersCount)/Double(p5Total) * 100
//        let p6AmbersPercent: Double = p6Total == 0 ? 0.0 : Double(p6AmbersCount)/Double(p6Total) * 100
//        let p7AmbersPercent: Double = p7Total == 0 ? 0.0 : Double(p7AmbersCount)/Double(p7Total) * 100
//        
//            // Calculate percentage of 'Green' RAG assessments - by period
//        let p1GreensPercent: Double = p1Total == 0 ? 0.0 : Double(p1GreensCount)/Double(p1Total) * 100
//        let p2GreensPercent: Double = p2Total == 0 ? 0.0 : Double(p2GreensCount)/Double(p2Total) * 100
//        let p3GreensPercent: Double = p3Total == 0 ? 0.0 : Double(p3GreensCount)/Double(p3Total) * 100
//        let p4GreensPercent: Double = p4Total == 0 ? 0.0 : Double(p4GreensCount)/Double(p4Total) * 100
//        let p5GreensPercent: Double = p5Total == 0 ? 0.0 : Double(p5GreensCount)/Double(p5Total) * 100
//        let p6GreensPercent: Double = p6Total == 0 ? 0.0 : Double(p6GreensCount)/Double(p6Total) * 100
//        let p7GreensPercent: Double = p7Total == 0 ? 0.0 : Double(p7GreensCount)/Double(p7Total) * 100
//        
//            // Calculate total number of RAG assessments - by day
//        let mondayTotal = mondayRedsCount + mondayAmbersCount + mondayGreensCount
//        let tuesdayTotal = tuesdayRedsCount + tuesdayAmbersCount + tuesdayGreensCount
//        let wednesdayTotal = wednesdayRedsCount + wednesdayAmbersCount + wednesdayGreensCount
//        let thursdayTotal = thursdayRedsCount + thursdayAmbersCount + thursdayGreensCount
//        let fridayTotal = fridayRedsCount + fridayAmbersCount + fridayGreensCount
//        
//            // Calculate percentage of 'Red' RAG assessments - by day
//        let mondayRedsPercent: Double = mondayTotal == 0 ? 0.0 : Double(mondayRedsCount)/Double(mondayTotal) * 100
//        let tuesdayRedsPercent: Double = tuesdayTotal == 0 ? 0.0 : Double(tuesdayRedsCount)/Double(tuesdayTotal) * 100
//        let wednesdayRedsPercent: Double = wednesdayTotal == 0 ? 0.0 : Double(wednesdayRedsCount)/Double(wednesdayTotal) * 100
//        let thursdayRedsPercent: Double = thursdayTotal == 0 ? 0.0 : Double(thursdayRedsCount)/Double(thursdayTotal) * 100
//        let fridayRedsPercent: Double = fridayTotal == 0 ? 0.0 : Double(fridayRedsCount)/Double(fridayTotal) * 100
//        
//            // Calculate percentage of 'Amber' RAG assessments - by day
//        let mondayAmbersPercent: Double = mondayTotal == 0 ? 0.0 : Double(mondayAmbersCount)/Double(mondayTotal) * 100
//        let tuesdayAmbersPercent: Double = tuesdayTotal == 0 ? 0.0 : Double(tuesdayAmbersCount)/Double(tuesdayTotal) * 100
//        let wednesdayAmbersPercent: Double = wednesdayTotal == 0 ? 0.0 : Double(wednesdayAmbersCount)/Double(wednesdayTotal) * 100
//        let thursdayAmbersPercent: Double = thursdayTotal == 0 ? 0.0 : Double(thursdayAmbersCount)/Double(thursdayTotal) * 100
//        let fridayAmbersPercent: Double = fridayTotal == 0 ? 0.0 : Double(fridayAmbersCount)/Double(fridayTotal) * 100
//        
//            // Calculate percentage of 'Green' RAG assessments - by day
//        let mondayGreensPercent: Double = mondayTotal == 0 ? 0.0 : Double(mondayGreensCount)/Double(mondayTotal) * 100
//        let tuesdayGreensPercent: Double = tuesdayTotal == 0 ? 0.0 : Double(tuesdayGreensCount)/Double(tuesdayTotal) * 100
//        let wednesdayGreensPercent: Double = wednesdayTotal == 0 ? 0.0 : Double(wednesdayGreensCount)/Double(wednesdayTotal) * 10
//        let thursdayGreensPercent: Double = thursdayTotal == 0 ? 0.0 : Double(thursdayGreensCount)/Double(thursdayTotal) * 100
//        let fridayGreensPercent: Double = fridayTotal == 0 ? 0.0 : Double(fridayGreensCount)/Double(fridayTotal) * 100
//        
//            // Calculate Day View Incident percentages - by period
//        let p1IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(p1IncidentsCount)/Double(totalIncidents) * 100
//        let p2IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(p2IncidentsCount)/Double(totalIncidents) * 100
//        let p3IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(p3IncidentsCount)/Double(totalIncidents) * 100
//        let l1IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(l1IncidentsCount)/Double(totalIncidents) * 100
//        let l2IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(l2IncidentsCount)/Double(totalIncidents) * 100
//        let p4IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(p4IncidentsCount)/Double(totalIncidents) * 100
//        let p5IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(p5IncidentsCount)/Double(totalIncidents) * 100
//        let p6IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(p6IncidentsCount)/Double(totalIncidents) * 100
//        let p7IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(p7IncidentsCount)/Double(totalIncidents) * 100
//        
//            // Calculate Week View Incident percentages - by day
//        let mondayIncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(mondayIncidentsCount)/Double(totalIncidents) * 100
//        let tuesdayIncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(tuesdayIncidentsCount)/Double(totalIncidents) * 100
//        let wednesdayIncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(wednesdayIncidentsCount)/Double(totalIncidents) * 100
//        let thursdayIncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(thursdayIncidentsCount)/Double(totalIncidents) * 100
//        let fridayIncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(fridayIncidentsCount)/Double(totalIncidents) * 100
//        
//            // Package-up Day View percentages - by period
//        let dayViewReds: [Double] = [p1RedsPercent, p2RedsPercent, p3RedsPercent, 0.0, 0.0, p4RedsPercent, p5RedsPercent, p6RedsPercent, p7RedsPercent]
//        let dayViewAmbers: [Double] = [p1AmbersPercent, p2AmbersPercent, p3AmbersPercent, 0.0, 0.0, p4AmbersPercent, p5AmbersPercent, p6AmbersPercent, p7AmbersPercent]
//        let dayViewGreens: [Double] = [p1GreensPercent, p2GreensPercent, p3GreensPercent, 0.0, 0.0, p4GreensPercent, p5GreensPercent, p6GreensPercent, p7GreensPercent]
//        let dayViewIncidents: [Double] = [p1IncidentsPercent, p2IncidentsPercent, p3IncidentsPercent, l1IncidentsPercent, l2IncidentsPercent, p4IncidentsPercent, p5IncidentsPercent, p6IncidentsPercent, p7IncidentsPercent]
//        
//            // Package-up Week View percentages - per day
//        let weekViewReds: [Double] = [mondayRedsPercent, tuesdayRedsPercent, wednesdayRedsPercent, thursdayRedsPercent, fridayRedsPercent]
//        let weekViewAmbers: [Double] = [mondayAmbersPercent, tuesdayAmbersPercent, wednesdayAmbersPercent, thursdayAmbersPercent, fridayAmbersPercent]
//        let weekViewGreens: [Double] = [mondayGreensPercent, tuesdayGreensPercent, wednesdayGreensPercent, thursdayGreensPercent, fridayGreensPercent]
//        let weekViewIncidents: [Double] = [mondayIncidentsPercent, tuesdayIncidentsPercent, wednesdayIncidentsPercent, thursdayIncidentsPercent, fridayIncidentsPercent]
//
//            // Calculate average incident intensity
//        let averageIncidentIntensity: Float = totalIncidents == 0 ? 0.0 : round((intensityTotal / Float(totalIncidents)) * 10) / 10
//
//            // Calculate Behaviour-types percentages
//        let kicking: Double = totalIncidents == 0 ? 0.0 : Double(kickingCount)/Double(totalIncidents) * 100
//        let headbutt: Double = totalIncidents == 0 ? 0.0 : Double(headbuttCount)/Double(totalIncidents) * 100
//        let hitting: Double = totalIncidents == 0 ? 0.0 : Double(hittingCount)/Double(totalIncidents) * 100
//        let biting: Double = totalIncidents == 0 ? 0.0 : Double(bitingCount)/Double(totalIncidents) * 100
//        let slapping: Double = totalIncidents == 0 ? 0.0 : Double(slappingCount)/Double(totalIncidents) * 100
//        let scratching: Double = totalIncidents == 0 ? 0.0 : Double(scratchingCount)/Double(totalIncidents) * 100
//        let clothesGrabbing: Double = totalIncidents == 0 ? 0.0 : Double(clothesGrabbingCount)/Double (totalIncidents) * 100
//        let hairPulling: Double = totalIncidents == 0 ? 0.0 : Double(hairPullingCount)/Double(totalIncidents) * 100
//
//            // Calculate Purpose-types percentages
//        let socialAttention: Double = totalIncidents == 0 ? 0.0 : Double(socialAttentionCount)/Double(totalIncidents) * 100
//        let tangibles: Double = totalIncidents == 0 ? 0.0 : Double(tangiblesCount)/Double(totalIncidents) * 100
//        let escape: Double = totalIncidents == 0 ? 0.0 : Double(escapeCount)/Double(totalIncidents) * 100
//        let sensory: Double = totalIncidents == 0 ? 0.0 : Double(sensoryCount)/Double(totalIncidents) * 100
//        let health: Double = totalIncidents == 0 ? 0.0 : Double(healthCount)/Double(totalIncidents) * 100
//        let activityAvoidance: Double = totalIncidents == 0 ? 0.0 : Double(activityAvoidanceCount)/Double(totalIncidents) * 100
//        let unknown: Double = totalIncidents == 0 ? 0.0 : Double(unknownCount)/Double(totalIncidents) * 100
//
//        // Compile and return AdminReportDataSet object - using calculated values
//    return AdminReportDataSet(dayViewReds: (p1: dayViewReds[0], p2: dayViewReds[1], p3: dayViewReds[2], l1: dayViewReds[3], l2: dayViewReds[4], p4: dayViewReds[5], p5: dayViewReds[6], p6: dayViewReds[7], p7: dayViewReds[8]), dayViewAmbers: (p1: dayViewAmbers[0], p2: dayViewAmbers[1], p3: dayViewAmbers[2], l1: dayViewAmbers[3], l2: dayViewAmbers[4], p4: dayViewAmbers[5], p5: dayViewAmbers[6], p6: dayViewAmbers[7], p7: dayViewAmbers[8]), dayViewGreens: (p1: dayViewGreens[0], p2: dayViewGreens[1], p3: dayViewGreens[2], l1: dayViewGreens[3], l2: dayViewGreens[4], p4: dayViewGreens[5], p5: dayViewGreens[6], p6: dayViewGreens[7], p7: dayViewGreens[8]), dayViewIncidents: (p1: dayViewIncidents[0], p2: dayViewIncidents[1], p3: dayViewIncidents[2], l1: dayViewIncidents[3], l2: dayViewIncidents[4], p4: dayViewIncidents[5], p5: dayViewIncidents[6], p6: dayViewIncidents[7], p7: dayViewIncidents[8]), weekViewReds: (mon: weekViewReds[0], tue: weekViewReds[1], wed: weekViewReds[2], thu: weekViewReds[3], fri: weekViewReds[4]), weekViewAmbers: (mon: weekViewAmbers[0], tue: weekViewAmbers[1], wed: weekViewAmbers[2], thu: weekViewAmbers[3], fri: weekViewAmbers[4]), weekViewGreens: (mon: weekViewGreens[0], tue: weekViewGreens[1], wed: weekViewGreens[2], thu: weekViewGreens[3], fri: weekViewGreens[4]), weekViewIncidents: (mon: weekViewIncidents[0], tue: weekViewIncidents[1], wed: weekViewIncidents[2], thu: weekViewIncidents[3], fri: weekViewIncidents[4]), totalIncidents: totalIncidents, averageIncidentIntensity: averageIncidentIntensity, behaviours: (kicking: kicking, headbutt: headbutt, hitting: hitting, biting: biting, slapping: slapping, scratching: scratching, clothesGrabbing: clothesGrabbing, hairPulling: hairPulling), purposes: (socialAttention: socialAttention, tangibles: tangibles, escape: escape, sensory: sensory, health: health, activityAvoidance: activityAvoidance, unknown: unknown))
//    }
//    
//    
//    static func saveRAGAssessments(ragAssessments: [RAGAssessment]) {
//        for rag in ragAssessments {
//            print ("\(rag.studentNumber): \(rag.assessment)")
//        }
//    }
//    
// 
//    
//    // Returns the Mean average value in an array of Doubles
//    static func getAverage(of doubleArray: [Double]) -> Double {
//        let sumArray = doubleArray.reduce(0, +)
//        let aveArray = sumArray / Double(doubleArray.count)
//        return round(aveArray * 10) / 10
//    }
//    
//    
//    // Returns the String representation of a given Date's 'Day' value
//    static func getDayString(for dateOffset: Int) -> String {
//        
//        let noonToday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
//        let requiredDay = Calendar.current.date(byAdding: .day, value: dateOffset, to: noonToday)!
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        return dateFormatter.string(from: requiredDay)
//    }
//    
//    
//    // Returns the String representation of a given Date's 'Day' value
//    static func getDayString(for date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        return dateFormatter.string(from: date)
//    }
//    
//    
//    // Returns the String representation of a Date (with a given offset from the current date) - in "1st January 2018 " format
//    static func getDateString(for dateOffset: Int) -> String {
//        
//        let noonToday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
//        let requiredDay = Calendar.current.date(byAdding: .day, value: dateOffset, to: noonToday)!
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd"
//        let dayNumber = dateFormatter.string(from: requiredDay)
//        dateFormatter.dateFormat = "MMMM"
//        let monthName = dateFormatter.string(from: requiredDay)
//        dateFormatter.dateFormat = "YYYY"
//        let year = dateFormatter.string(from: requiredDay)
//        return "\(dayNumber) \(monthName) \(year)"
//        
//    }
//    
//    // Returns the String representation of a given Date - in short "01/01/2018" format
//    static func getShortDateString(for date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yy"
//        return dateFormatter.string(from: date)
//    }
//    
//    // Returns the String representaion of a given Date's 'Time' value
//    static func getTimeString(for date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .none
//        dateFormatter.timeStyle = .short
//        return dateFormatter.string(from: date)
//    }

}
//
//// ---------
//extension String {
//    func toBool() -> Bool? {
//        switch self {
//        case "True", "true", "yes", "1":
//            return true
//        case "False", "false", "no", "0":
//            return false
//        default:
//            return nil
//        }
//    }
//}
//
//
//
///// for checking current time against end of periods
//extension Date
//{
//    
//    // Returns the Date-representation of a given time of the current day
//    func dateAt(hours: Int, minutes: Int) -> Date
//    {
//        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
//        
//        //get the month/day/year componentsfor today's date.
//        var date_components = calendar.components(
//            [NSCalendar.Unit.year,
//             NSCalendar.Unit.month,
//             NSCalendar.Unit.day],
//            from: self)
//        
//        //Create an NSDate for the specified time today.
//        date_components.hour = hours
//        date_components.minute = minutes
//        date_components.second = 0
//        
//        let newDate = calendar.date(from: date_components)!
//        return newDate
//    }
//    
//    
//    func withOffset(dateOffset: Int) -> Date {
//        let noonToday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
//        return Calendar.current.date(byAdding: .day, value: dateOffset, to: noonToday)!
//    }
//    
//    
//    func dateFor(day: Int, month: Int, year: Int) -> Date? {
//        
//            // Initialize Date components
//        var c = NSDateComponents()
//        c.year = year
//        c.month = month
//        c.day = day
//        
//            // Get NSDate given the above date components
//        if let date = NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: c as DateComponents) {
//            return date
//        } else {
//            return nil
//        }
//    }
//    
//}
//
//// Provide constrained values for different available reporting time periods
//enum TimePeriod: CustomStringConvertible {
//    case today
//    case currentWeek
//    case lastWeek
//    case thisTerm
//    case lastTerm
//    case thisYear
//    case lastYear
//    case allTime
//    
//    var description: String {
//        switch self {
//        case .today:
//            return "Today"
//        case .currentWeek:
//            return "Current Week"
//        case .lastWeek:
//            return "Last Week"
//        case .thisTerm:
//            return "This Term"
//        case .lastTerm:
//            return "Last Term"
//        case .thisYear:
//            return "This Year"
//        case .lastYear:
//            return "Last Year"
//        case .allTime:
//            return "All Time"
//        }
//    }
//}


