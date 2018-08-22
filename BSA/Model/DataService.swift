//
//  DataService.swift
//  BSA
//
//  Created by Pete Holdsworth on 24/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

import Firebase
import FirebaseDatabase

protocol AdminCreationDelegate {
    func didCreateAdminAccount()
}

protocol UserAccountFetchingDelegate {
    func finishedFetching(userAccounts: [UserAccount])
}

protocol SchoolClassFetchingDelegate {
    func finishedFetching(schoolClasses: [SchoolClass])
}

protocol StaffFetchingDelegate {
    func finishedFetching(staffMembers: [Staff])
}

protocol StudentFetchingDelegate {
    func finishedFetching(students: [Student])
    func finishedFetching(classesWithStudents: [(schoolClass: SchoolClass, students: [Student])])
}

protocol BehaviourFetchingDelegate {
    func finishedFetching(behaviours: [String])
}

protocol PurposeFetchingDelegate {
    func finishedFetching(purposes: [String])
}

protocol RAGAssessmentsFetchingDelegate {
    func finishedFetching(rAGAssessments: [RAGAssessment])
}

protocol IncidentsFetchingDelegate {
    func finishedFetching(incidents: [Incident])
}


class DataService {
    
    
    var mainRef: DatabaseReference = Database.database().reference()
    var userAccountsRef: DatabaseReference = Database.database().reference().child(Constants.FIREBASE_USER_ACCOUNTS)
    var schoolClassRef: DatabaseReference = Database.database().reference().child(Constants.FIREBASE_SCHOOL_CLASSES)
    var staffRef: DatabaseReference = Database.database().reference().child(Constants.FIREBASE_STAFF)
    var studentsRef: DatabaseReference = Database.database().reference().child(Constants.FIREBASE_STUDENTS)
    var rAGAssessmentsRef: DatabaseReference = Database.database().reference().child(Constants.FIREBASE_RAG_ASSESSMENTS)
    var incidentsRef: DatabaseReference = Database.database().reference().child(Constants.FIREBASE_INCIDENTS)
    
    var userAccountFetchingDelegate: UserAccountFetchingDelegate?
    var schoolClassFetchingDelegate: SchoolClassFetchingDelegate?
    var staffFetchingDelegate: StaffFetchingDelegate?
    var studentFetchingDelegate: StudentFetchingDelegate?
    var rAGAssessmentsFetchingDelegate: RAGAssessmentsFetchingDelegate?
    var incidentsFetchingDelegate: IncidentsFetchingDelegate?
    
    
    // Admin account --------
    
    // Creates the 'Admin' User Account object in the Firebase database
    func createAdminAccount(completion: @escaping (_ success: Bool, _ message: String?) -> Void) {

        let adminAccount: Dictionary<String, AnyObject> = [
            Constants.FIREBASE_USER_ACCOUNT_NAME : "Admin" as AnyObject,
            Constants.FIREBASE_USER_ACCOUNT_SECURITY_LEVEL : 0 as AnyObject,
            Constants.FIREBASE_USER_ACCOUNT_CLASS_ID : "" as AnyObject,
            Constants.FIREBASE_USER_ACCOUNT_PASSWORD : "password" as AnyObject]

        mainRef.child(Constants.FIREBASE_USER_ACCOUNTS).child(NSUUID().uuidString).updateChildValues(adminAccount) { (error, ref) in
            if error != nil { // upload error occurred - provide feedback
                completion(false, error!.localizedDescription)
            } else { // callback once media upload complete
                completion(true, "admin account created!")
            }
        }
    }
    
    
    
    // ---------- User Accounts
    
    // Creates a new User Account object in the Firebase database
    func createUserAccount(userAccount: UserAccount, completion: @escaping (_ success: Bool, _ message: String?) -> Void) {

        let account: Dictionary<String, AnyObject> = [
            Constants.FIREBASE_USER_ACCOUNT_NAME : userAccount.accountName as AnyObject,
            Constants.FIREBASE_USER_ACCOUNT_SECURITY_LEVEL : userAccount.securityLevel as AnyObject,
            Constants.FIREBASE_USER_ACCOUNT_CLASS_ID : userAccount.schoolClassId as AnyObject,
            Constants.FIREBASE_USER_ACCOUNT_PASSWORD : userAccount.password as AnyObject]

        userAccountsRef.child(userAccount.id).updateChildValues(account) { (error, ref) in
            if error != nil { // upload error occurred - provide feedback
                completion(false, "Error creating User Account: \(userAccount.accountName) - \(error!.localizedDescription)")
            } else { // callback once media upload complete
                completion(true, "User Account: \(userAccount.accountName) - created!")
            }
        }
    }
    
    
    // Searches Database for all User Accounts. Asynchronous method - call-back returns an array of User Account object.If not found, returns nil.
    func getAllUserAccounts() {
        let queryRef = userAccountsRef
        queryRef.queryOrdered(byChild: Constants.FIREBASE_USER_ACCOUNT_NAME).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                var fetchedUserAccounts = [UserAccount]()
                
                for snap in snapshots {
                    
                    let storedAccountID = snap.key
                    let storedAccountName = snap.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNT_NAME).value as! String
                    let storedSecurityLevel = snap.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNT_SECURITY_LEVEL).value as! Int
                    let storedSchoolClassID = snap.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNT_CLASS_ID).value as! String
                    let storedPassword = snap.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNT_PASSWORD).value as! String
                    
                    let storedUserAccount = UserAccount(
                        id: storedAccountID,
                        accountName: storedAccountName,
                        securityLevel: storedSecurityLevel,
                        schoolClassId: storedSchoolClassID,
                        password: storedPassword
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
            let storedAccountName = snapshot.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNT_NAME).value as! String
            let storedSecurityLevel = snapshot.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNT_SECURITY_LEVEL).value as! Int
            let storedSchoolClassId = snapshot.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNT_CLASS_ID).value as! String
            let storedPassword = snapshot.childSnapshot(forPath: Constants.FIREBASE_USER_ACCOUNT_PASSWORD).value as! String
            
            let storedUserAccount = UserAccount(
                id: storedAccountID,
                accountName: storedAccountName,
                securityLevel: storedSecurityLevel,
                schoolClassId: storedSchoolClassId,
                password: storedPassword)
            
            fetchedUserAccounts.append(storedUserAccount)
            
            self.userAccountFetchingDelegate?.finishedFetching(userAccounts: fetchedUserAccounts)
            
        })
    }
    
    
    func deleteUserAccount() {
        
    }
    
    
    // ---------- School Classes
    
    // Creates  a new School Class object in the Firebase database. If the new object is created successfully, a new User Account object is also created in the database - associated with the School Class object.
    func createSchoolClass(schoolClass: SchoolClass, onComplete: @escaping (_ classId: String?, _ message: String?) -> Void) {
        
        let newSchoolClass: Dictionary<String, AnyObject> = [
            Constants.FIREBASE_SCHOOL_CLASS_NAME : schoolClass.className as AnyObject
        ]
            // create School Class object
        schoolClassRef.child(schoolClass.id).updateChildValues(newSchoolClass) { (error, ref) in
            if error != nil {
                // deal with error
            } else {
                // save successful
                onComplete(schoolClass.id, schoolClass.className)
            }
        }
    }
    
    
    // Searches Database for all School Classes.Asynchronous method - call-back returns an array of School Class objects. If not found, returns nil.
    func getAllSchoolClasses() {
        let queryRef = schoolClassRef
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                var fetchedSchoolClasses = [SchoolClass]()
                
                for snap in snapshots {
                    
                    let storedSchoolClassID = snap.key
                    let storedSchoolClassName = snap.childSnapshot(forPath: Constants.FIREBASE_SCHOOL_CLASS_NAME).value as! String
                    
                    let storedSchoolClass = SchoolClass(
                        id: storedSchoolClassID,
                        className: storedSchoolClassName)
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
        })
    }
    
    
    // ---------- Staff
    
    // Creates a new Staff object in the Firebase database
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
        })
    }
    
    
    
    // ---------- Students
    
    // Creates a new Student object in the Firebase database
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
                    let storedStudentClassId = snap.childSnapshot(forPath: Constants.FIREBASE_STUDENT_CLASS_ID).value as! String
                    
                    let storedStudent = Student(
                        id: storedStudentID,
                        studentNumber: storedStudentNumber,
                        firstName: storedStudentFirstName,
                        lastName: storedStudentLastName,
                        schoolClassId: storedStudentClassId)
                    
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
            
            fetchedStudents.append(storedStudent)
            
            self.studentFetchingDelegate?.finishedFetching(students: fetchedStudents)
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
                    allStudents.append(storedStudent)
                    
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
    
    // -------- Entity Deletion
    
    // Deletes a given entity from Firebase database
    func delete(entity: Any, account: UserAccount?, completion: @escaping (_ success: Bool, _ message: String?) -> Void) {
        
            // if School-Class object passed in for deletion
        if let schoolClass = entity as? SchoolClass {
            guard account != nil else {
                print ("no associated account passed in for deletion with school class")
                return
            }
            
            schoolClassRef.child(schoolClass.id).removeValue { (error, ref) in
                if error != nil {
                    completion(false, error?.localizedDescription)
                } else {
                        // also delete associated user account
                    self.userAccountsRef.child(account!.id).removeValue()
                    completion(true, nil)
                }
            }
            
            // if Staff object passed in for deletion
        } else if let staffMember = entity as? Staff {
            staffRef.child(staffMember.id).removeValue { (error, ref) in
                if error != nil {
                    completion(false, error?.localizedDescription)
                } else {
                    completion(true, nil)
                }
            }
            
            // if Student object passed in for deletion
        } else if let student = entity as? Student {
            studentsRef.child(student.id).removeValue { (error, ref) in
                if error != nil {
                    completion(false, error?.localizedDescription)
                } else {
                    completion(true, nil)
                }
            }
        }
    }
    
    
    
    // -------- RAG Assessments
    
    // Creates a new RAG Assessment object in the Firebase database
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
    
    // Searches Database for all RAG Assessments associated with a given set of Students. Asynchronous method - call-back returns an array of RAG Assessment objects.  If not found, returns nil.
    func getAllRAGAssessments(for students: [Student]) {
        let queryRef = rAGAssessmentsRef
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                var studentNumbers = [Int]()
                for student in students {
                    studentNumbers.append(student.studentNumber)
                }
                
                var fetchedRAGAssessments = [RAGAssessment]()
                
                for snap in snapshots {
                    
                    let storedRAGAssessmentID = snap.key
                    let storedRAGAssessmentDate = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_DATE).value as! Double
                    let storedRAGAssessmentPeriod = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_PERIOD).value as! String
                    let storedRAGAssessmentStudentNumber = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_STUDENT).value as! Int
                    let storedRAGAssessmentAssessmentStatus = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_STATUS).value as! String
                    
                    let storedRAGAssessment = RAGAssessment(
                        id: storedRAGAssessmentID,
                        date: Date(timeIntervalSince1970: TimeInterval(storedRAGAssessmentDate)),
                        period: storedRAGAssessmentPeriod,
                        studentNumber: storedRAGAssessmentStudentNumber,
                        assessment: storedRAGAssessmentAssessmentStatus)
                    
                    if studentNumbers.contains(storedRAGAssessment.studentNumber) {
                        fetchedRAGAssessments.append(storedRAGAssessment)
                    }

                }
                self.rAGAssessmentsFetchingDelegate?.finishedFetching(rAGAssessments: fetchedRAGAssessments)
            }
        })
    }
    
    
    // Returns all RAG Assessment objects from the Firebase database - for a given selection of Students, and in a given time-period.
    func getRAGAssessments(for students: [Student], fromTimePeriod timePeriod: TimePeriod) {
        
        let timePeriodStartDate = DataService.getTimePeriodStartDate(for: timePeriod)!
        let timePeriodEndDate = DataService.getTimePeriodEndDate(for: timePeriod)!
        
        let queryRef = rAGAssessmentsRef
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                
                var studentNumbers = [Int]()
                for student in students {
                    studentNumbers.append(student.studentNumber)
                }
                
                var fetchedRAGAssessments = [RAGAssessment]()
                
                for snap in snapshots {
                    
                    let storedRAGAssessmentID = snap.key
                    let storedRAGAssessmentDate = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_DATE).value as! Double
                    let storedRAGAssessmentPeriod = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_PERIOD).value as! String
                    let storedRAGAssessmentStudentNumber = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_STUDENT).value as! Int
                    let storedRAGAssessmentAssessmentStatus = snap.childSnapshot(forPath: Constants.FIREBASE_RAG_ASSESSMENT_STATUS).value as! String
                    
                    let storedRAGAssessment = RAGAssessment(
                        id: storedRAGAssessmentID,
                        date: Date(timeIntervalSince1970: TimeInterval(storedRAGAssessmentDate)),
                        period: storedRAGAssessmentPeriod,
                        studentNumber: storedRAGAssessmentStudentNumber,
                        assessment: storedRAGAssessmentAssessmentStatus)
    
                    if studentNumbers.contains(storedRAGAssessment.studentNumber) && storedRAGAssessment.date >= timePeriodStartDate && storedRAGAssessment.date <= timePeriodEndDate {
                        fetchedRAGAssessments.append(storedRAGAssessment)
                    }
                    
                }
                self.rAGAssessmentsFetchingDelegate?.finishedFetching(rAGAssessments: fetchedRAGAssessments)
            }
        })
    }
    
    
    
    // -------- Incidents
    
    // Creates a new Incident object in the Firebase database
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
    
    // Searches Database for all Incidents. Asynchronous method - call-back returns an array of Incident objects. If not found, returns nil.
    func getAllIncidents() {
        let queryRef = incidentsRef
        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                var fetchedIncidents = [Incident]()
                
                for snap in snapshots {
                    
                    let storedIncidentID = snap.key
                    let storedIncidentDate = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_DATE).value as! Double
                    let storedIncidentDuration = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_DURATION).value as! Int
                    let storedIncidentStudent = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_STUDENT).value as! Int
                    
                    var storedIncidentBehaviours = [String]()
                    let incidentBehaviours = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_BEHAVIOURS).value
                    for behaviour in incidentBehaviours  as! [String: Any] {
                        storedIncidentBehaviours.append(behaviour.value as! String)
                    }
                    
                    let intensityNumber = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_INTENSITY).value as! NSNumber
                    let storedIncidentIntensity = intensityNumber.floatValue
                    
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

    
    // Returns all Incident objects from the Firebase database for a given selection of Students.
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
                    let storedIncidentDate = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_DATE).value as! Double
                    let storedIncidentDuration = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_DURATION).value as! Int
                    let storedIncidentStudent = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_STUDENT).value as! Int
                    
                    var storedIncidentBehaviours = [String]()
                    let incidentBehaviours = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_BEHAVIOURS).value
                    for behaviour in incidentBehaviours  as! [String: Any] {
                        storedIncidentBehaviours.append(behaviour.value as! String)
                    }
                    
                    let intensityNumber = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_INTENSITY).value as! NSNumber
                    let storedIncidentIntensity = intensityNumber.floatValue
                    
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
    
    
    // Returns all Incident objects from the Firebase database - for a given selection of Students, and in a given time-period.
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
                    let storedIncidentDate = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_DATE).value as! Double
                    let storedIncidentDuration = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_DURATION).value as! Int
                    let storedIncidentStudent = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_STUDENT).value as! Int
                    
                    var storedIncidentBehaviours = [String]()
                    let incidentBehaviours = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_BEHAVIOURS).value
                    for behaviour in incidentBehaviours  as! [String: Any] {
                        storedIncidentBehaviours.append(behaviour.value as! String)
                    }
                    
                    let intensityNumber = snap.childSnapshot(forPath: Constants.FIREBASE_INCIDENT_INTENSITY).value as! NSNumber
                    let storedIncidentIntensity = intensityNumber.floatValue
                    
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
    
    
    
    // ------- General Ananlysis Support
    
    // Returns a Date value for the start-point of a given TimePeriod
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
    
    // Returns the number of periods that have already been passed in the current day
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
    
    
    // Returns a Date value for the end-point of a given TimePeriod
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



// ----- Type extensions

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
    
    // Returns the Date-representation of noon for a day that is offset from the current day by a given number
    func withOffset(dateOffset: Int) -> Date {
        let noonToday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
        return Calendar.current.date(byAdding: .day, value: dateOffset, to: noonToday)!
    }
    
    // Returns a Date value for a given set of integers representing day, month and year
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

