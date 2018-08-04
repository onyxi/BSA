//
//  DataService.swift
//  BSA
//
//  Created by Pete Holdsworth on 24/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

//(album.availableDate.timeIntervalSince1970 * 1000).rounded() as AnyObject

import Foundation

import Firebase
import FirebaseDatabase

protocol AdminCreationDelegate {
    func didCreateAdminAccount()
}

protocol UserAccountFetchingDelegate {
//    func finishedFetchingAllUserAccounts(userAccounts: [UserAccount]?)
//    func finishedFetchingSingleUserAccount(userAccount: UserAccount?)
    func finishedFetching(userAccounts: [UserAccount])
}

protocol SchoolClassFetchingDelegate {
//    func finishedFetchingAllSchoolClasses(schoolClasses: [SchoolClass]?)
//    func finishedFetchingSingleSchoolClass(schoolClass: SchoolClass?)
    func finishedFetching(schoolClasses: [SchoolClass])
}

protocol StaffFetchingDelegate {
//    func finishedFetchingAllStaffMembers(staffMembers: [Staff]?)
//    func finishedFetchingSingleStaffMember(staffMember: Staff?)
    func finishedFetching(staffMembers: [Staff])
}

protocol StudentFetchingDelegate {
//    func finishedFetchingAllStudents(students: [Student]?)
//    func finishedFetchingSingleStudent(student: Student?)
//    func finishedFetchingStudentsForClass(students: [Student]?, schoolClass: SchoolClass)
    func finishedFetching(students: [Student])
    func finishedFetching(classesWithStudents: [(schoolClass: SchoolClass, students: [Student])])
}

protocol BehaviourFetchingDelegate {
//    func finishedFetchingAllBehaviours(behaviours: [Behaviour]?)
    func finishedFetching(behaviours: [String])
}

protocol PurposeFetchingDelegate {
//    func finishedFetchingAllPurposes(purposes: [Purpose]?)
    func finishedFetching(purposes: [String])
}

protocol RAGAssessmentsFetchingDelegate {
    func finishedFetching(rAGAssessments: [RAGAssessment])
}

protocol IncidentsFetchingDelegate {
    func finishedFetching(incidents: [Incident])
}


//typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

class DataService {
    
    
    var mainRef: DatabaseReference = Database.database().reference()
    var userAccountsRef: DatabaseReference = Database.database().reference().child(Constants.FIREBASE_USER_ACCOUNTS)
    var schoolClassRef: DatabaseReference = Database.database().reference().child(Constants.FIREBASE_SCHOOL_CLASSES)
    var staffRef: DatabaseReference = Database.database().reference().child(Constants.FIREBASE_STAFF)
    var studentsRef: DatabaseReference = Database.database().reference().child(Constants.FIREBASE_STUDENTS)
//    var behavioursRef: DatabaseReference = Database.database().reference().child(Constants.FIREBASE_BEHAVIOURS)
//    var purposesRef: DatabaseReference = Database.database().reference().child(Constants.FIREBASE_PURPOSES)
    var rAGAssessmentsRef: DatabaseReference = Database.database().reference().child(Constants.FIREBASE_RAG_ASSESSMENTS)
    var incidentsRef: DatabaseReference = Database.database().reference().child(Constants.FIREBASE_INCIDENTS)
    
    var userAccountFetchingDelegate: UserAccountFetchingDelegate?
    var schoolClassFetchingDelegate: SchoolClassFetchingDelegate?
    var staffFetchingDelegate: StaffFetchingDelegate?
    var studentFetchingDelegate: StudentFetchingDelegate?
//    var behaviourFetchingDelegate: BehaviourFetchingDelegate?
//    var purposeFetchingDelegate: PurposeFetchingDelegate?
    var rAGAssessmentsFetchingDelegate: RAGAssessmentsFetchingDelegate?
    var incidentsFetchingDelegate: IncidentsFetchingDelegate?
    
    
    
    // Upload Admin account --------
    
    func createAdminAccount(completion: @escaping (_ success: Bool, _ message: String?) -> Void) {

        let adminAccount: Dictionary<String, AnyObject> = [
            Constants.FIREBASE_USER_ACCOUNTS_NAME : "Admin" as AnyObject,
            Constants.FIREBASE_USER_ACCOUNTS_SECURITY_LEVEL : 0 as AnyObject,
            Constants.FIREBASE_USER_ACCOUNTS_CLASS_ID : "" as AnyObject]

        mainRef.child(Constants.FIREBASE_USER_ACCOUNTS).child(NSUUID().uuidString).updateChildValues(adminAccount) { (error, ref) in
            if error != nil { // upload error occurred - provide feedback
                completion(false, error!.localizedDescription)
            } else { // callback once media upload complete
                completion(true, "admin account created!")
            }
        }
    }
    
    
    // ---------- User Accounts
    
    func createUserAccount(userAccount: UserAccount, completion: @escaping (_ success: Bool, _ message: String?) -> Void) {

        let account: Dictionary<String, AnyObject> = [
            Constants.FIREBASE_USER_ACCOUNTS_NAME : userAccount.accountName as AnyObject,
            Constants.FIREBASE_USER_ACCOUNTS_SECURITY_LEVEL : userAccount.securityLevel as AnyObject,
            Constants.FIREBASE_USER_ACCOUNTS_CLASS_ID : userAccount.schoolClassId as AnyObject]

        userAccountsRef.child(userAccount.id).updateChildValues(account) { (error, ref) in
            if error != nil { // upload error occurred - provide feedback
                completion(false, "Error creating User Account: \(userAccount.accountName) - \(error!.localizedDescription)")
            } else { // callback once media upload complete
                completion(true, "User Account: \(userAccount.accountName) - created!")
            }
        }
    }
    
    
    func createSchoolClass(schoolClass: SchoolClass, completion: @escaping (_ classId: String?, _ message: String?) -> Void) {
        
        let newSchoolClass: Dictionary<String, AnyObject> = [
            Constants.FIREBASE_SCHOOL_CLASS_NAME : schoolClass.className as AnyObject
        ]
        
        schoolClassRef.child(schoolClass.id).updateChildValues(newSchoolClass) { (error, ref) in
            if error != nil {
                // handle upload failure
                print (error)
//                print ("Error creating School Class: \(error!.localizedDescription)")
            } else {
                let newUserAccount = UserAccount(
                    id: Constants.getUniqueId(),
                    accountName: schoolClass.className,
                    securityLevel: 1,
                    schoolClassId: schoolClass.id)
//                    String(ref))
                self.createUserAccount(userAccount: newUserAccount, completion: { (success, message) in
                    if success {
                        print ("New Class created: \(schoolClass.className)")
                        print (message)
                        completion(schoolClass.id, schoolClass.className)
                    } else {
                        print (message)
                        completion(nil, "failed")
                    }
                })
            }
            
        }
    }
    
    
    
    func createStaffMember(staffMember: Staff, completion: @escaping (_ staffId: String?, _ message: String?) -> Void) {
        
        let newStaffMember: Dictionary<String, AnyObject> = [
            Constants.FIREBASE_STAFF_NUMBER : staffMember.staffNumber as AnyObject,
            Constants.FIREBASE_STAFF_FIRST_NAME : staffMember.firstName as AnyObject,
            Constants.FIREBASE_STAFF_LAST_NAME : staffMember.lastName as AnyObject]
        
        staffRef.child(staffMember.id).updateChildValues(newStaffMember) { (error, ref) in
            if error != nil { // upload error occurred - provide feedback
                completion(nil, "Error creating User Account: \(staffMember.firstName) \(staffMember.lastName) - \(error!.localizedDescription)")
            } else { // callback once media upload complete
                completion(staffMember.id, "User Account: \(staffMember.firstName) \(staffMember.lastName) - created!")
            }
        }
    }
    
    
    
    
    func createStudent(student: Student, completion: @escaping (_ studentId: String?, _ message: String?) -> Void) {
        
        let newStudent: Dictionary<String, AnyObject> = [
            Constants.FIREBASE_STUDENT_NUMBER : student.studentNumber as AnyObject,
            Constants.FIREBASE_STUDENT_FIRST_NAME : student.firstName as AnyObject,
            Constants.FIREBASE_STUDENT_LAST_NAME : student.lastName as AnyObject,
            Constants.FIREBASE_STUDENT_CLASS_ID : student.schoolClassId as AnyObject,
            ]
        
        studentsRef.child(student.id).updateChildValues(newStudent) { (error, ref) in
            if error != nil { // upload error occurred - provide feedback
                completion(nil, "Error creating Student: \(student.firstName) \(student.lastName) - \(error!.localizedDescription)")
            } else { // callback once media upload complete
                completion(student.id, "Student: \(student.firstName) \(student.lastName) - created!")
            }
        }
    }
    
    
    
//     func createStaffMember(staffMember: Staff, completion: @escaping (_ staffId: String?, _ message: String?) -> Void) {
    func createRAGAssessment(rAGAssessment: RAGAssessment, completion: @escaping (_ rAGAssessmentId: String?, _ message: String?) -> Void) {
        
        let newRAGAssessment: Dictionary<String, AnyObject> = [
            Constants.FIREBASE_RAG_ASSESSMENT_DATE : rAGAssessment.date.timeIntervalSince1970 as AnyObject,
            Constants.FIREBASE_RAG_ASSESSMENT_PERIOD : rAGAssessment.period as AnyObject,
            Constants.FIREBASE_RAG_ASSESSMENT_STUDENT : rAGAssessment.studentNumber as AnyObject,
            Constants.FIREBASE_RAG_ASSESSMENT_STATUS : rAGAssessment.assessment as AnyObject
            ]
        
        rAGAssessmentsRef.child(rAGAssessment.id).updateChildValues(newRAGAssessment) { (error, ref) in
            if error != nil { // upload error occurred - provide feedback
                completion(nil, "Error creating RAG Assessment: \(rAGAssessment.assessment) - \(error!.localizedDescription)")
            } else { // callback once media upload complete
                completion(rAGAssessment.id, "RAG Assessment: \(rAGAssessment.assessment) - created!")
            }
        }
    }
    
    
    
//    DataService().createIncident(id: incident.id , incident: incident) { (incidentId, message) in
    func createIncident(incident: Incident, completion: @escaping (_ incidentId: String?, _ message: String?) -> Void) {
        
        var incidentBehaviours = [String: Any]()
        for behaviour in incident.behaviours {
            incidentBehaviours[Constants.getUniqueId()] = behaviour as AnyObject
        }
        
        var incidentStaff = [String: Any]()
        for staff in incident.staff {
            incidentStaff[Constants.getUniqueId()] = String(staff) as AnyObject
        }
        
        var incidentPurposes = [String: Any]()
        for purpose in incident.purposes {
            incidentPurposes[Constants.getUniqueId()] = purpose as AnyObject
        }
        
        let newIncident: Dictionary<String, AnyObject> = [
            Constants.FIREBASE_INCIDENT_DATE : incident.dateTime.timeIntervalSince1970 as AnyObject,
            Constants.FIREBASE_INCIDENT_DURATION : incident.duration as AnyObject,
            Constants.FIREBASE_INCIDENT_STUDENT : incident.student as AnyObject,
            Constants.FIREBASE_INCIDENT_BEHAVIOURS : incidentBehaviours as AnyObject,
            Constants.FIREBASE_INCIDENT_INTENSITY : incident.intensity as AnyObject,
            Constants.FIREBASE_INCIDENT_STAFF : incidentStaff as AnyObject,
            Constants.FIREBASE_INCIDENT_ACCIDENT_FORM : incident.accidentFormCompleted as AnyObject,
            Constants.FIREBASE_INCIDENT_RESTRAINT : incident.restraint as AnyObject,
            Constants.FIREBASE_INCIDENT_ALARM_PRESSED : incident.alarmPressed as AnyObject,
            Constants.FIREBASE_INCIDENT_PURPOSES : incidentPurposes as AnyObject,
            Constants.FIREBASE_INCIDENT_NOTES : incident.notes as AnyObject]
        
        incidentsRef.child(incident.id).updateChildValues(newIncident) { (error, ref) in
            if error != nil { // upload error occurred - provide feedback
                completion(nil, "Error creating Incident: \(error!.localizedDescription)")
            } else { // callback once media upload complete
                completion(incident.id, "Incident - created!")
            }
        }
    }
    
    
    
    
    
    
    
    
    // Searches Database for all User Accounts. Asynchronous method - call-back returns an array of User Account object.If not found, returns nil.
    func getAllUserAccounts() {
        let queryRef = userAccountsRef
        queryRef.queryOrdered(byChild: Constants.FIREBASE_USER_ACCOUNTS_NAME).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {

                var fetchedUserAccounts = [UserAccount]()
                
                for snap in snapshots {
     
                    let storedAccountID = snap.key
                    let storedAccountName = snap.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNTS_NAME).value as! String
                    let storedSecurityLevel = snap.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNTS_SECURITY_LEVEL).value as! Int
                    let storedSchoolClassID = snap.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNTS_CLASS_ID).value as! String

                    let storedUserAccount = UserAccount(
                        id: storedAccountID,
                        accountName: storedAccountName,
                        securityLevel: storedSecurityLevel,
                        schoolClassId: storedSchoolClassID
                        )

                    fetchedUserAccounts.append(storedUserAccount)
                }
                self.userAccountFetchingDelegate?.finishedFetching(userAccounts: fetchedUserAccounts)
            }
        })
    }
    
    

    // Searches Database for a single User Account with a given id. Asynchronous method - call-back returns an array with single User Account object. If not found, returns nil.
    func getUserAccountWithID(withId id: String) {
        let queryRef = userAccountsRef.child(id)
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var fetchedUserAccounts = [UserAccount]()
            
            let storedAccountID = snapshot.key
            let storedAccountName = snapshot.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNTS_NAME).value as! String
            let storedSecurityLevel = snapshot.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNTS_SECURITY_LEVEL).value as! Int
            let storedSchoolClassId = snapshot.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNTS_CLASS_ID).value as! String
            
            let storedUserAccount = UserAccount(
                id: storedAccountID,
                accountName: storedAccountName,
                securityLevel: storedSecurityLevel,
                schoolClassId: storedSchoolClassId)
            
            fetchedUserAccounts.append(storedUserAccount)
            
            self.userAccountFetchingDelegate?.finishedFetching(userAccounts: fetchedUserAccounts)
            
            
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//
//                var fetchedUserAccounts = [UserAccount]()
//
//                for snap in snapshots {
//
//                    let storedAccountID = snap.key
//                    let storedAccountName = snap.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNTS_NAME).value as! String
//                    let storedSecurityLevel = snap.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNTS_SECURITY_LEVEL).value as! Int
//                    let storedSchoolClassId = snap.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNTS_CLASS_ID).value as! String
//
//                    let storedUserAccount = UserAccount(
//                        id: storedAccountID,
//                        accountName: storedAccountName,
//                        securityLevel: storedSecurityLevel,
//                        schoolClassId: storedSchoolClassId)
////                    let storedUserAccount = UserAccount(
////                        id: storedAccountID,
////                        accountName: storedAccountName,
////                        securityLevel: Int(storedSecurityLevel)!,
////                        schoolClassNumber: Int(storedSchoolClassNumber))
//
//                   fetchedUserAccounts.append(storedUserAccount)
//                }
////                self.userAccountFetchingDelegate?.finishedFetching(userAccounts: fetchedUserAccounts)
//            }
        })
    }
    
    
    
    
    // ---------- School Classes
    
    // Searches Database for all School Classes.Asynchronous method - call-back returns an array of School Class objects. If not found, returns nil.
    func getAllSchoolClasses() {
        let queryRef = schoolClassRef
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                var fetchedSchoolClasses = [SchoolClass]()
                
                for snap in snapshots {
                    
                    let storedSchoolClassID = snap.key
//                    let storedSchoolClassNumber = snap.childSnapshot(forPath: Constants.FIREBASE_SCHOOL_CLASS_NUMBER).value as! String
                    let storedSchoolClassName = snap.childSnapshot(forPath: Constants.FIREBASE_SCHOOL_CLASS_NAME).value as! String

                    let storedSchoolClass = SchoolClass(
                        id: storedSchoolClassID,
                        className: storedSchoolClassName)
//                    let storedSchoolClass = SchoolClass(
//                        id: storedSchoolClassID,
//                        classNumber: Int(storedSchoolClassNumber)!,
//                        className: storedSchoolClassName)

                    fetchedSchoolClasses.append(storedSchoolClass)
                }
                self.schoolClassFetchingDelegate?.finishedFetching(schoolClasses: fetchedSchoolClasses)
            }
        })
    }
    
    
    
    // Searches Database for a single School Class with a given id. Asynchronous method - call-back returns an array with single School Class object. If not found, returns nil.
    func getSchoolClass(withId id: String) {
        let queryRef = schoolClassRef.child(id)
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var fetchedSchoolClasses = [SchoolClass]()
            
            let storedSchoolClassID = id
            let storedSchoolClassName = snapshot.childSnapshot(forPath: Constants.FIREBASE_SCHOOL_CLASS_NAME).value as! String
            
            let storedSchoolClass = SchoolClass(
                id: storedSchoolClassID,
                className: storedSchoolClassName)
            
            fetchedSchoolClasses.append(storedSchoolClass)
            
            self.schoolClassFetchingDelegate?.finishedFetching(schoolClasses: fetchedSchoolClasses)
            
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//
//                var fetchedSchoolClasses = [SchoolClass]()
//
//                let storedSchoolClassID = id
//                let storedSchoolClassName = snap.childSnapshot(forPath: Constants.FIREBASE_SCHOOL_CLASS_NAME).value as! String
//
//                for snap in snapshots {
//                    print("ClassID: \(snap.key) , Name: ")
//                    let storedSchoolClassID = id
////                    let storedSchoolClassNumber = snap.childSnapshot(forPath: Constants.FIREBASE_SCHOOL_CLASS_NUMBER).value as! String
//                    let storedSchoolClassName = snap.childSnapshot(forPath: Constants.FIREBASE_SCHOOL_CLASS_NAME).value as! String
//
//                    let storedSchoolClass = SchoolClass(
//                        id: storedSchoolClassID,
//                        className: storedSchoolClassName)
////                    let storedSchoolClass = SchoolClass(
////                        id: storedSchoolClassID,
////                        classNumber: Int(storedSchoolClassNumber)!,
////                        className: storedSchoolClassName)
//
//                    fetchedSchoolClasses.append(storedSchoolClass)
//                }
            
//            }
        })
    }
    
    
    
    
    
    // ---------- Staff
    
    // Searches Database for all Staff Members. Asynchronous method - call-back returns an array of Staff object. If not found, returns nil.
    func getAllStaffMembers() {
        let queryRef = staffRef
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                var fetchedStaffMembers = [Staff]()
                
                for snap in snapshots {
                    
                    let storedStaffMemberID = snap.key
                    let storedStaffMemberNumber = snap.childSnapshot(forPath: Constants.FIREBASE_STAFF_NUMBER).value as! Int
                    let storedStaffMemberFirstName = snap.childSnapshot(forPath: Constants.FIREBASE_STAFF_FIRST_NAME).value as! String
                    let storedStaffMemberLastName = snap.childSnapshot(forPath: Constants.FIREBASE_STAFF_LAST_NAME).value as! String
                    
                    let storedStaffMember = Staff(
                        id: storedStaffMemberID,
                        staffNumber: storedStaffMemberNumber,
                        firstName: storedStaffMemberFirstName,
                        lastName: storedStaffMemberLastName)
                    
                    fetchedStaffMembers.append(storedStaffMember)
                }
                self.staffFetchingDelegate?.finishedFetching(staffMembers: fetchedStaffMembers)
            }
        })
    }
    
    
    
    // Searches Database for a single Staff Member with a given id. Asynchronous method - call-back returns an array with single Staff object. If not found, returns nil.
    func getStaffMember(withId id: String) {
        let queryRef = staffRef.child(id)
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var fetchedStaffMembers = [Staff]()
                
            let storedStaffMemberID = snapshot.key
            let storedStaffMemberNumber = snapshot.childSnapshot(forPath: Constants.FIREBASE_STAFF_NUMBER).value as! Int
            let storedStaffMemberFirstName = snapshot.childSnapshot(forPath: Constants.FIREBASE_STAFF_FIRST_NAME).value as! String
            let storedStaffMemberLastName = snapshot.childSnapshot(forPath: Constants.FIREBASE_STAFF_LAST_NAME).value as! String
                
            let storedStaffMember = Staff(
                id: storedStaffMemberID,
                staffNumber: storedStaffMemberNumber,
                firstName: storedStaffMemberFirstName,
                lastName: storedStaffMemberLastName)
                
            fetchedStaffMembers.append(storedStaffMember)
            
            self.staffFetchingDelegate?.finishedFetching(staffMembers: fetchedStaffMembers)
            
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//
//                var fetchedStaffMembers = [Staff]()
//
//                for snap in snapshots {
//
//                    let storedStaffMemberID = snap.key
//                    let storedStaffMemberNumber = snap.childSnapshot(forPath: Constants.FIREBASE_STAFF_NUMBER).value as! String
//                    let storedStaffMemberFirstName = snap.childSnapshot(forPath: Constants.FIREBASE_STAFF_FIRST_NAME).value as! String
//                    let storedStaffMemberLastName = snap.childSnapshot(forPath: Constants.FIREBASE_STAFF_LAST_NAME).value as! String
//
//                    let storedStaffMember = Staff(
//                        id: storedStaffMemberID,
//                        staffNumber: Int(storedStaffMemberNumber)!,
//                        firstName: storedStaffMemberFirstName,
//                        lastName: storedStaffMemberLastName)
//
//                    fetchedStaffMembers.append(storedStaffMember)
//                }
//                self.staffFetchingDelegate?.finishedFetching(staffMembers: fetchedStaffMembers)
//            }
        })
    }
    
    
    // ---------- Students
    
    // Searches Database for all Students. Asynchronous method - call-back returns an array of Student objects. If not found, returns nil.
    func getAllStudents() {
        let queryRef = studentsRef
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                var fetchedStudents = [Student]()
                
                for snap in snapshots {
                    
                    let storedStudentID = snap.key
                    let storedStudentNumber = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_NUMBER).value as! Int
                    let storedStudentFirstName = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_FIRST_NAME).value as! String
                    let storedStudentLastName = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_LAST_NAME).value as! String
//                    let storedStudentClassNumber = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_CLASS_NUMBER).value as! String
                    let storedStudentClassId = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_CLASS_ID).value as! String
                    
                    let storedStudent = Student(
                        id: storedStudentID,
                        studentNumber: storedStudentNumber,
                        firstName: storedStudentFirstName,
                        lastName: storedStudentLastName,
                        schoolClassId: storedStudentClassId)
//                        schoolClassNumber: Int(storedStudentClassNumber)!)
                    
                    fetchedStudents.append(storedStudent)
                }
                self.studentFetchingDelegate?.finishedFetching(students: fetchedStudents)
            }
        })
    }
    
    
    
    // Searches Database for a single Student with a given id. Asynchronous method - call-back returns an array with single Student object.  If not found, returns nil.
    func getStudent(withId id: String) {
        let queryRef = studentsRef.child(id)
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var fetchedStudents = [Student]()
                
            let storedStudentID = snapshot.key
            let storedStudentNumber = snapshot.childSnapshot(forPath: Constants.FIREBASE_STUDENT_NUMBER).value as! Int
            let storedStudentFirstName = snapshot.childSnapshot(forPath: Constants.FIREBASE_STUDENT_FIRST_NAME).value as! String
            let storedStudentLastName = snapshot.childSnapshot(forPath: Constants.FIREBASE_STUDENT_LAST_NAME).value as! String
                //                    let storedStudentClassNumber = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_CLASS_NUMBER).value as! String
            let storedStudentClassId = snapshot.childSnapshot(forPath: Constants.FIREBASE_STUDENT_CLASS_ID).value as! String
                
            let storedStudent = Student(
                id: storedStudentID,
                studentNumber: storedStudentNumber,
                firstName: storedStudentFirstName,
                lastName: storedStudentLastName,
                schoolClassId: storedStudentClassId)
                //                        schoolClassNumber: Int(storedStudentClassNumber)!)
                
            fetchedStudents.append(storedStudent)
            
            self.studentFetchingDelegate?.finishedFetching(students: fetchedStudents)
//
//
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//
//                var fetchedStudents = [Student]()
//
//                for snap in snapshots {
//
//                    let storedStudentID = snap.key
//                    let storedStudentNumber = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_NUMBER).value as! String
//                    let storedStudentFirstName = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_FIRST_NAME).value as! String
//                    let storedStudentLastName = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_LAST_NAME).value as! String
////                    let storedStudentClassNumber = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_CLASS_NUMBER).value as! String
//                    let storedStudentClassId = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_CLASS_ID).value as! String
//
//                    let storedStudent = Student(
//                        id: storedStudentID,
//                        studentNumber: Int(storedStudentNumber)!,
//                        firstName: storedStudentFirstName,
//                        lastName: storedStudentLastName,
//                        schoolClassId: storedStudentClassId)
////                        schoolClassNumber: Int(storedStudentClassNumber)!)
//
//                    fetchedStudents.append(storedStudent)
//                }
//                self.studentFetchingDelegate?.finishedFetching(students: fetchedStudents)
//            }
        })
    }
    
    
    
    // Searches Database for all Students associated with a given School Class. Asynchronous method - call-back returns an array of Student objects.  If not found, returns nil.
    func getStudents(for schoolClass: SchoolClass) {
        let queryRef = studentsRef
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                var fetchedStudents = [Student]()
                
                for snap in snapshots {
                    
                    let storedStudentID = snap.key
                    let storedStudentNumber = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_NUMBER).value as! Int
                    let storedStudentFirstName = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_FIRST_NAME).value as! String
                    let storedStudentLastName = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_LAST_NAME).value as! String
                    let storedStudentClassId = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_CLASS_ID).value as! String

                    let storedStudent = Student(
                        id: storedStudentID,
                        studentNumber: storedStudentNumber,
                        firstName: storedStudentFirstName,
                        lastName: storedStudentLastName,
                        schoolClassId: storedStudentClassId)
//                        schoolClassNumber: Int(storedStudentClassNumber)!)

                    if storedStudent.schoolClassId == schoolClass.id {
                        fetchedStudents.append(storedStudent)
                    }
                }
                self.studentFetchingDelegate?.finishedFetching(students: fetchedStudents)
            }
        })
    }
    
    // Searches Database for all Students associated with a given set of School Classes. Asynchronous method - call-back returns an array of tuples containing a School Class aobject and array of associated Student objects.  If not found, returns nil.
    func getStudents(for schoolClasses: [SchoolClass]) {
        let queryRef = studentsRef
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                var allStudents = [Student]()
                    
                for snap in snapshots {

                    let storedStudentID = snap.key
                    let storedStudentNumber = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_NUMBER).value as! Int
                    let storedStudentFirstName = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_FIRST_NAME).value as! String
                    let storedStudentLastName = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_LAST_NAME).value as! String
                    let storedStudentClassId = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_CLASS_ID).value as! String

                    let storedStudent = Student(
                        id: storedStudentID,
                        studentNumber: storedStudentNumber,
                        firstName: storedStudentFirstName,
                        lastName: storedStudentLastName,
                        schoolClassId: storedStudentClassId)
//                        schoolClassNumber: Int(storedStudentClassNumber)!)
                    allStudents.append(storedStudent)
                    
//                    for schoolClass in fetchedClassesWithStudents {
//                        if schoolClass.schoolClass.classNumber == storedStudent.schoolClassNumber {
//                            schoolClass.students.append(storedStudent)
//                        }
//                    }
    
                }
                
                var fetchedClassesWithStudents = [  (schoolClass: SchoolClass, students: [Student])  ]()
                
                for schoolClass in schoolClasses {
                    var classStudents = [Student]()
                    for student in allStudents {
                        if student.schoolClassId == schoolClass.id {
                            classStudents.append(student)
                        }
                    }
                    let classWithStudents = (schoolClass: schoolClass, students: classStudents)
                    fetchedClassesWithStudents.append( classWithStudents )
                }
                
                
                self.studentFetchingDelegate?.finishedFetching(classesWithStudents: fetchedClassesWithStudents)
            }
        })
    }
    
    
    
    
    
    // -------- Behaviours
    // Searches Database for all Behaviours. Asynchronous method - call-back returns an array of Behaviour objects. If not found, returns nil.
//    func getAllBehaviours() {
//        let queryRef = behavioursRef
//        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//
//                var fetchedBehaviours = [Behaviour]()
//
//                for snap in snapshots {
//
//                    let storedBehaviourID = snap.key
//                    let storedBehaviourType = snap.childSnapshot(forPath: Constants.FIREBASE_BEHAVIOUR_TYPE).value as! String
//
//                    let storedBehaviour = Behaviour(
//                        id: storedBehaviourID,
//                        type: storedBehaviourType)
//
//                    fetchedBehaviours.append(storedBehaviour)
//                }
//                self.behaviourFetchingDelegate?.finishedFetching(behaviours: fetchedBehaviours)
//            }
//        })
//    }
    
    
    
    // -------- Purposes
    
    // Searches Database for all Purposes. Asynchronous method - call-back returns an array of Purpose objects. If not found, returns nil.
//    func getAllPurposes() {
//        let queryRef = purposesRef
//        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//
//                var fetchedPurposes = [Purpose]()
//
//                for snap in snapshots {
//
//                    let storedPurposeID = snap.key
//                    let storedPurposeType = snap.childSnapshot(forPath: Constants.FIREBASE_PURPOSE_TYPE).value as! String
//
//                    let storedPurpose = Purpose(
//                        id: storedPurposeID,
//                        type: storedPurposeType)
//
//                    fetchedPurposes.append(storedPurpose)
//                }
//                self.purposeFetchingDelegate?.finishedFetching(purposes: fetchedPurposes)
//            }
//        })
//    }
    
    
    
    // -------- RAG Assessments
    
    // Searches Database for all RAG Assessments associated with a given set of Students. Asynchronous method - call-back returns an array of RAG Assessment objects.  If not found, returns nil.
    func getAllRAGAssessments(for students: [Student]) {
        let queryRef = rAGAssessmentsRef
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
          
                var fetchedRAGAssessments = [RAGAssessment]()
                
                 for snap in snapshots {
                    
                    let storedRAGAssessmentID = snap.key
                    let storedRAGAssessmentDate = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_DATE).value as! Int
                    let storedRAGAssessmentPeriod = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_PERIOD).value as! String
                    let storedRAGAssessmentStudentNumber = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_STUDENT).value as! Int
                    let storedRAGAssessmentAssessmentStatus = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_STATUS).value as! String

                    let storedRAGAssessment = RAGAssessment(
                        id: storedRAGAssessmentID,
                        date: Date(timeIntervalSince1970: TimeInterval(storedRAGAssessmentDate)),
                        period: storedRAGAssessmentPeriod,
                        studentNumber: storedRAGAssessmentStudentNumber,
                        assessment: storedRAGAssessmentAssessmentStatus)

                    fetchedRAGAssessments.append(storedRAGAssessment)
                }
                self.rAGAssessmentsFetchingDelegate?.finishedFetching(rAGAssessments: fetchedRAGAssessments)
            }
        })
    }
    
    
    

    func getRAGAssessments(for students: [Student], fromTimePeriod timePeriod: TimePeriod) {
        
        let timePeriodStartDate = DataService.getTimePeriodStartDate(for: timePeriod)!
        let timePeriodEndDate = DataService.getTimePeriodEndDate(for: timePeriod)!
        
//        print (DataService.getShortDateString(for: timePeriodStartDate))
//        print (DataService.getShortDateString(for: timePeriodEndDate))
        
        let queryRef = rAGAssessmentsRef
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                var fetchedRAGAssessments = [RAGAssessment]()
                
                for snap in snapshots {
                    
                    let storedRAGAssessmentID = snap.key
                    let storedRAGAssessmentDate = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_DATE).value as! Int
                    let storedRAGAssessmentPeriod = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_PERIOD).value as! String
                    let storedRAGAssessmentStudentNumber = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_STUDENT).value as! Int
                    let storedRAGAssessmentAssessmentStatus = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_STATUS).value as! String

                    let storedRAGAssessment = RAGAssessment(
                        id: storedRAGAssessmentID,
                        date: Date(timeIntervalSince1970: TimeInterval(storedRAGAssessmentDate)),
                        period: storedRAGAssessmentPeriod,
                        studentNumber: storedRAGAssessmentStudentNumber,
                        assessment: storedRAGAssessmentAssessmentStatus)
    

                    if storedRAGAssessment.date >= timePeriodStartDate && storedRAGAssessment.date <= timePeriodEndDate {
                        fetchedRAGAssessments.append(storedRAGAssessment)
                    }
                    
                }
                self.rAGAssessmentsFetchingDelegate?.finishedFetching(rAGAssessments: fetchedRAGAssessments)
            }
        })
    }
    
    
    
    
    
    
    
    
    
    // -------- Incidents
    
    
    // Searches Database for all Incidents. Asynchronous method - call-back returns an array of Incident objects. If not found, returns nil.
    func getAllIncidents() {
        let queryRef = incidentsRef
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                var fetchedIncidents = [Incident]()
                
                for snap in snapshots {
                    
                    let storedIncidentID = snap.key
//                    let storedIncidentNumber = snap.childSnapshot(forPath: Constants.FIREBASE_BEHAVIOUR_TYPE).value as! String
                    let storedIncidentDate = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_DATE).value as! Int
                    let storedIncidentDuration = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_DURATION).value as! Int
                    let storedIncidentStudent = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_STUDENT).value as! Int
                    
                    var storedIncidentBehaviours = [String]()
                    let incidentBehaviours = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_BEHAVIOURS).value
                    for behaviour in incidentBehaviours  as! [String: Any] {
                        storedIncidentBehaviours.append(behaviour.value as! String)
                    }
                    
                    let storedIncidentIntensity = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_INTENSITY).value as! Float
                    
                    var storedIncidentStaff = [Int]()
                    let incidentStaff = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_STAFF).value
                    for staff in incidentStaff as! [String: Any] {
                        storedIncidentStaff.append(Int(staff.value as! String)!)
                    }
                    
                    let storedIncidentAccidentForm = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_ACCIDENT_FORM).value as! Bool
                    let storedIncidentRestraint = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_RESTRAINT).value as! String
                    let storedIncidentAlarmPressed = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_ALARM_PRESSED).value as! Bool
                    
                    var storedIncidentPurposes = [String]()
                    let incidentPurposes = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_PURPOSES).value
                    for purpose in incidentPurposes  as! [String: Any] {
                        storedIncidentPurposes.append(purpose.value as! String)
                    }
                    
                    let storedIncidentNotes = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_NOTES).value as! String
                    
                    let storedIncident = Incident(
                        id: storedIncidentID,
//                        incidentNumber: storedIncidentNumber,
                        dateTime: Date(timeIntervalSince1970: TimeInterval(storedIncidentDate)),
                        duration: storedIncidentDuration,
                        student: storedIncidentStudent,
                        behaviours: storedIncidentBehaviours,
                        intensity: storedIncidentIntensity,
                        staff: storedIncidentStaff,
                        accidentFormCompleted: storedIncidentAccidentForm,
                        restraint: storedIncidentRestraint,
                        alarmPressed: storedIncidentAlarmPressed,
                        purposes: storedIncidentPurposes,
                        notes: storedIncidentNotes)

                    fetchedIncidents.append(storedIncident)
                    
                }
                self.incidentsFetchingDelegate?.finishedFetching(incidents: fetchedIncidents)
            }
        })
    }

    
    
    
    func getIncidents(for students: [Student]){
        
        var studentNumbers = [Int]()
        
        for student in students {
            studentNumbers.append(student.studentNumber)
        }
        
        let queryRef = incidentsRef
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                var fetchedIncidents = [Incident]()
                
                for snap in snapshots {
                    
                    let storedIncidentID = snap.key
//                    let storedIncidentNumber = snap.childSnapshot(forPath: Constants.FIREBASE_BEHAVIOUR_TYPE).value as! String
                    let storedIncidentDate = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_DATE).value as! Int
                    let storedIncidentDuration = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_DURATION).value as! Int
                    let storedIncidentStudent = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_STUDENT).value as! Int
                    
                    var storedIncidentBehaviours = [String]()
                    let incidentBehaviours = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_BEHAVIOURS).value
                    for behaviour in incidentBehaviours  as! [String: Any] {
                        storedIncidentBehaviours.append(behaviour.value as! String)
                    }
                    
                    let storedIncidentIntensity = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_INTENSITY).value as! Float
                    
                    var storedIncidentStaff = [Int]()
                    let incidentStaff = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_STAFF).value
                    for staff in incidentStaff as! [String: Any] {
                        storedIncidentStaff.append(Int(staff.value as! String)!)
                    }
                    
                    let storedIncidentAccidentForm = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_ACCIDENT_FORM).value as! Bool
                    let storedIncidentRestraint = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_RESTRAINT).value as! String
                    let storedIncidentAlarmPressed = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_ALARM_PRESSED).value as! Bool
                    
                    var storedIncidentPurposes = [String]()
                    let incidentPurposes = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_PURPOSES).value
                    for purpose in incidentPurposes  as! [String: Any] {
                        storedIncidentPurposes.append(purpose.value as! String)
                    }
                    
                    let storedIncidentNotes = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_NOTES).value as! String


                    let storedIncident = Incident(
                        id: storedIncidentID,
//                        incidentNumber: storedIncidentNumber,
                        dateTime: Date(timeIntervalSince1970: TimeInterval(storedIncidentDate)),
                        duration: storedIncidentDuration,
                        student: storedIncidentStudent,
                        behaviours: storedIncidentBehaviours,
                        intensity: storedIncidentIntensity,
                        staff: storedIncidentStaff,
                        accidentFormCompleted: storedIncidentAccidentForm,
                        restraint: storedIncidentRestraint,
                        alarmPressed: storedIncidentAlarmPressed,
                        purposes: storedIncidentPurposes,
                        notes: storedIncidentNotes)

                    if studentNumbers.contains(storedIncident.student) {
                        fetchedIncidents.append(storedIncident)
                    }
                    
                }
                self.incidentsFetchingDelegate?.finishedFetching(incidents: fetchedIncidents)
            }
        })
    }
    
    
    
    
    
    
    
    func getIncidents(for students: [Student], fromTimePeriod timePeriod: TimePeriod) {
        
        var studentNumbers = [Int]()
        
        for student in students {
            studentNumbers.append(student.studentNumber)
        }
        
        let timePeriodStartDate = DataService.getTimePeriodStartDate(for: timePeriod)!
        let timePeriodEndDate = DataService.getTimePeriodEndDate(for: timePeriod)!
        
        let queryRef = incidentsRef
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                var fetchedIncidents = [Incident]()
                
                for snap in snapshots {
                    
                    let storedIncidentID = snap.key
//                    let storedIncidentNumber = snap.childSnapshot(forPath: Constants.FIREBASE_BEHAVIOUR_TYPE).value as! String
                    let storedIncidentDate = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_DATE).value as! Int
                    let storedIncidentDuration = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_DURATION).value as! Int
                    let storedIncidentStudent = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_STUDENT).value as! Int
                    
                    var storedIncidentBehaviours = [String]()
                    let incidentBehaviours = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_BEHAVIOURS).value
                    for behaviour in incidentBehaviours  as! [String: Any] {
                        storedIncidentBehaviours.append(behaviour.value as! String)
                    }

                    let storedIncidentIntensity = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_INTENSITY).value as! Float
                    
                    var storedIncidentStaff = [Int]()
                    let incidentStaff = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_STAFF).value
                    for staff in incidentStaff as! [String: Any] {
                        storedIncidentStaff.append(Int(staff.value as! String)!)
                    }

                    let storedIncidentAccidentForm = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_ACCIDENT_FORM).value as! Bool
                    let storedIncidentRestraint = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_RESTRAINT).value as! String
                    let storedIncidentAlarmPressed = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_ALARM_PRESSED).value as! Bool
                    
                    var storedIncidentPurposes = [String]()
                    let incidentPurposes = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_PURPOSES).value
                    for purpose in incidentPurposes  as! [String: Any] {
                        storedIncidentPurposes.append(purpose.value as! String)
                    }

                    let storedIncidentNotes = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_NOTES).value as! String
                
                    
                    let storedIncident = Incident(
                        id: storedIncidentID,
//                        incidentNumber: Int(storedIncidentNumber)!,
                        dateTime: Date(timeIntervalSince1970: TimeInterval(storedIncidentDate)),
                        duration: storedIncidentDuration,
                        student: storedIncidentStudent,
                        behaviours: storedIncidentBehaviours,
                        intensity: storedIncidentIntensity,
                        staff: storedIncidentStaff,
                        accidentFormCompleted: storedIncidentAccidentForm,
                        restraint: storedIncidentRestraint,
                        alarmPressed: storedIncidentAlarmPressed,
                        purposes: storedIncidentPurposes,
                        notes: storedIncidentNotes)

                    if studentNumbers.contains(storedIncident.student) && storedIncident.dateTime >= timePeriodStartDate && storedIncident.dateTime <= timePeriodEndDate {
                        fetchedIncidents.append(storedIncident)
                    }
                    
                }
                self.incidentsFetchingDelegate?.finishedFetching(incidents: fetchedIncidents)
            }
        })
        
    }
    
    
    
    // ------- Ananlysis
    
   
    
    
    
    
    
    
    
    
    
    
    static func getNumberOfPeriodsAlreadyPastToday() -> Int {
        
        var schoolDayPeriodsCount = 0
        
        if Date() > Date().dateAt(hours: Constants.P1_END_HOURS, minutes: Constants.P1_END_MINS) && Date() < Date().dateAt(hours: Constants.P2_END_HOURS, minutes: Constants.P2_END_MINS) {
            schoolDayPeriodsCount = 1
        } else if Date() >= Date().dateAt(hours: Constants.P2_END_HOURS, minutes: Constants.P2_END_MINS) && Date() < Date().dateAt(hours: Constants.P3_END_HOURS, minutes: Constants.P3_END_MINS) {
            schoolDayPeriodsCount = 2
        } else if Date() >= Date().dateAt(hours: Constants.P3_END_HOURS, minutes: Constants.P3_END_MINS) && Date() < Date().dateAt(hours: Constants.L1_END_HOURS, minutes: Constants.L1_END_MINS) {
            schoolDayPeriodsCount = 3
        } else if Date() >= Date().dateAt(hours: Constants.L1_END_HOURS, minutes: Constants.L1_END_MINS) && Date() < Date().dateAt(hours: Constants.L2_END_HOURS, minutes: Constants.L2_END_MINS) {
            schoolDayPeriodsCount = 4
        } else if Date() >= Date().dateAt(hours: Constants.L2_END_HOURS, minutes: Constants.L2_END_MINS) && Date() < Date().dateAt(hours: Constants.P4_END_HOURS, minutes: Constants.P4_END_MINS) {
            schoolDayPeriodsCount = 5
        } else if Date() >= Date().dateAt(hours: Constants.P4_END_HOURS, minutes: Constants.P4_END_MINS) && Date() < Date().dateAt(hours: Constants.P5_END_HOURS, minutes: Constants.P5_END_MINS) {
            schoolDayPeriodsCount = 6
        } else if Date() >= Date().dateAt(hours: Constants.P5_END_HOURS, minutes: Constants.P5_END_MINS) && Date() < Date().dateAt(hours: Constants.P6_END_HOURS, minutes: Constants.P6_END_MINS) {
            schoolDayPeriodsCount = 7
        } else if Date() >= Date().dateAt(hours: Constants.P6_END_HOURS, minutes: Constants.P6_END_MINS) && Date() < Date().dateAt(hours: Constants.P7_END_HOURS, minutes: Constants.P7_END_MINS) {
            schoolDayPeriodsCount = 8
        } else if Date() >= Date().dateAt(hours: Constants.P7_END_HOURS, minutes: Constants.P7_END_MINS) {
            schoolDayPeriodsCount = 9
        }
        
        return schoolDayPeriodsCount
    }
    
    
    static func getTimePeriodEndDate(for timePeriod: TimePeriod) -> Date? {
        
        switch timePeriod {
            
        case .today:
            return Date()
            
        case .currentWeek:
            return Date()
            
        case .lastWeek:
            
            switch getDayString(for: Date()) {
            case "Monday":
                return Date().dateAt(hours: 0, minutes: 0)
            case "Tuesday":
                return Date().withOffset(dateOffset: -1).dateAt(hours: 0, minutes: 0)
            case "Wednesday":
                return Date().withOffset(dateOffset: -2).dateAt(hours: 0, minutes: 0)
            case "Thursday":
                return Date().withOffset(dateOffset: -3).dateAt(hours: 0, minutes: 0)
            case "Friday":
                return Date().withOffset(dateOffset: -4).dateAt(hours: 0, minutes: 0)
            case "Saturday":
                return Date().withOffset(dateOffset: -5).dateAt(hours: 0, minutes: 0)
            case "Sunday":
                return Date().withOffset(dateOffset: -6).dateAt(hours: 0, minutes: 0)
            default: break
            }
            
        case .thisTerm:
            return Date()
        case .lastTerm:
            return Constants.LAST_TERM_END_TIME
        case .thisYear:
            return Date()
        case .lastYear:
            return Constants.LAST_YEAR_END_TIME
        case.allTime:
            return Date()
        }
        
        return nil
    }
    
    
    
    
    static func getTimePeriodStartDate(for timePeriod: TimePeriod) -> Date? {
        
        switch timePeriod {
            
        case .today:
            return Constants.TODAY_START_TIME
            
        case .currentWeek:
            
            switch getDayString(for: Date()) {
            case "Monday":
                return Date().dateAt(hours: 0, minutes: 0)
            case "Tuesday":
                return Date().withOffset(dateOffset: -1).dateAt(hours: 0, minutes: 0)
            case "Wednesday":
                return Date().withOffset(dateOffset: -2).dateAt(hours: 0, minutes: 0)
            case "Thursday":
                return Date().withOffset(dateOffset: -3).dateAt(hours: 0, minutes: 0)
            case "Friday":
                return Date().withOffset(dateOffset: -4).dateAt(hours: 0, minutes: 0)
            case "Saturday":
                return Date().withOffset(dateOffset: -5).dateAt(hours: 0, minutes: 0)
            case "Sunday":
                return Date().withOffset(dateOffset: -6).dateAt(hours: 0, minutes: 0)
            default: break
            }
            
        case .lastWeek:
            
            switch getDayString(for: Date()) {
            case "Monday":
                return Date().withOffset(dateOffset: -7).dateAt(hours: 0, minutes: 0)
            case "Tuesday":
                return Date().withOffset(dateOffset: -8).dateAt(hours: 0, minutes: 0)
            case "Wednesday":
                return Date().withOffset(dateOffset: -9).dateAt(hours: 0, minutes: 0)
            case "Thursday":
                return Date().withOffset(dateOffset: -10).dateAt(hours: 0, minutes: 0)
            case "Friday":
                return Date().withOffset(dateOffset: -11).dateAt(hours: 0, minutes: 0)
            case "Saturday":
                return Date().withOffset(dateOffset: -12).dateAt(hours: 0, minutes: 0)
            case "Sunday":
                return Date().withOffset(dateOffset: -13).dateAt(hours: 0, minutes: 0)
            default: break
            }
            
        case .thisTerm:
            return Constants.THIS_TERM_START_TIME
        case .lastTerm:
            return Constants.LAST_TERM_START_TIME
        case .thisYear:
            return Constants.THIS_YEAR_START_TIME
        case .lastYear:
            return Constants.LAST_YEAR_START_TIME
        case.allTime:
            return Constants.ALL_TIME_START_TIME
        }
        
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
//    
//    func saveUserAccount(userAccount: UserAccount, onComplete: @escaping Completion) {
//        
//        
//        let queryRef = self.mainRef.child(Constants.FIREBASE_USER_ACCOUNTS)
//        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
//          
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//                
//                var fetchedUserAccounts = [UserAccount]()
//                var accountNumbers = [0]
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
//                    
//                    fetchedUserAccounts.append(fetchedUserAccount)
//                    accountNumbers.append(Int(storedAccountNumber)!)
//                }
//                
//                let accountNumberToSave = accountNumbers.max()! + 1
//                
//                let userAccountForUpload: Dictionary<String, AnyObject> = [
//                    Constants.FIREBASE_USER_ACCOUNTS_NUMBER : String(accountNumberToSave) as AnyObject,
//                    Constants.FIREBASE_USER_ACCOUNTS_NAME : userAccount.accountName as AnyObject,
//                    Constants.FIREBASE_USER_ACCOUNTS_SECURITY_LEVEL : String(1) as AnyObject,
//                    Constants.FIREBASE_USER_ACCOUNTS_CLASS_NUMBER : userAccount.schoolClassNumber != nil ? String(userAccount.schoolClassNumber!) as AnyObject : "" as AnyObject
//                ]
//                
//                let accountID = userAccount.id == nil ? NSUUID().uuidString : userAccount.id
//                
//                self.mainRef.child(Constants.FIREBASE_USER_ACCOUNTS).child(accountID!).updateChildValues(userAccountForUpload, withCompletionBlock: { (error, ref) in
//                    
//                    if error != nil {
//                        onComplete("ERROR: \(String(describing: error))", ref)
//                    } else {
//                        print ("Success saving User Account!")
//                        onComplete(nil, ref)
//                    }
//                    
//                })
//                
//            }
//            
//            
//            
//            
//            
//        })
//    }
//    
//    
//    
    
    
    
    
    // Returns the Mean average value in an array of Doubles
    static func getAverage(of doubleArray: [Double]) -> Double {
        let sumArray = doubleArray.reduce(0, +)
        let aveArray = sumArray / Double(doubleArray.count)
        return round(aveArray * 10) / 10
    }
    
    
    // Returns the String representation of a given Date's 'Day' value
    static func getDayString(for dateOffset: Int) -> String {
        
        let noonToday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        let requiredDay = Calendar.current.date(byAdding: .day, value: dateOffset, to: noonToday)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: requiredDay)
    }
    
    
    // Returns the String representation of a given Date's 'Day' value
    static func getDayString(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    
    // Returns the String representation of a Date (with a given offset from the current date) - in "1st January 2018 " format
    static func getDateString(for dateOffset: Int) -> String {
        
        let noonToday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        let requiredDay = Calendar.current.date(byAdding: .day, value: dateOffset, to: noonToday)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let dayNumber = dateFormatter.string(from: requiredDay)
        dateFormatter.dateFormat = "MMMM"
        let monthName = dateFormatter.string(from: requiredDay)
        dateFormatter.dateFormat = "YYYY"
        let year = dateFormatter.string(from: requiredDay)
        return "\(dayNumber) \(monthName) \(year)"
        
    }
    
    // Returns the String representation of a given Date - in short "01/01/2018" format
    static func getShortDateString(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }
    
    // Returns the String representaion of a given Date's 'Time' value
    static func getTimeString(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
}







// ---------
extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}



/// for checking current time against end of periods
extension Date
{
    
    // Returns the Date-representation of a given time of the current day
    func dateAt(hours: Int, minutes: Int) -> Date
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
    
    
    func withOffset(dateOffset: Int) -> Date {
        let noonToday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
        return Calendar.current.date(byAdding: .day, value: dateOffset, to: noonToday)!
    }
    
    
    func dateFor(day: Int, month: Int, year: Int) -> Date? {
        
        // Initialize Date components
        var c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        
        // Get NSDate given the above date components
        if let date = NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: c as DateComponents) {
            return date
        } else {
            return nil
        }
    }
    
}

// Provide constrained values for different available reporting time periods
enum TimePeriod: CustomStringConvertible {
    case today
    case currentWeek
    case lastWeek
    case thisTerm
    case lastTerm
    case thisYear
    case lastYear
    case allTime
    
    var description: String {
        switch self {
        case .today:
            return "Today"
        case .currentWeek:
            return "Current Week"
        case .lastWeek:
            return "Last Week"
        case .thisTerm:
            return "This Term"
        case .lastTerm:
            return "Last Term"
        case .thisYear:
            return "This Year"
        case .lastYear:
            return "Last Year"
        case .allTime:
            return "All Time"
        }
    }
}
    
    
    
    
    
    
    
    

