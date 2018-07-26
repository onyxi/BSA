//
//  StudentSelectionVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 26/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows a selected Student object to be sent to the delegate
protocol StudentSelectionDelegate {
    func setStudent(to selection: Student)
}

class StudentSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, StudentFetchingDelegate {
    
    // UI handles:
    @IBOutlet weak var tableView: UITableView!
    
    // Properties:
    var studentSelectionDelegate: StudentSelectionDelegate?
    var allStudents = [Student]()
    var selectedStudent: Student?
    var selectedStudentNumber: Int?
    var schoolClass: SchoolClass?
    
    var dataService: DataService!
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()

            // set VC color and title
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Please Select..."
        
            // set up table of Students
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
            // retrieve Student objects from storage and reload table
        dataService = DataService()
        dataService.studentFetchingDelegate = self
        
        if UserDefaults.standard.integer(forKey: Constants.FIREBASE_USER_ACCOUNTS_NUMBER) == 0 {
            dataService.getAllStudents()
        } else {
            dataService.getSchoolClass(withId: UserDefaults.standard.string(forKey: Constants.LOGGED_IN_ACCOUNT_CLASS_ID)!)
        }
        
//        getSchoolClass()
        
//        getStudentsForAccount()
//        tableView.reloadData()
        
    }
    
    func getSchoolClass() {
//        if UserDefaults.standard.integer(forKey: Constants.LOGGED_IN_ACCOUNT_NUMBER_KEY) != 0 {
//            schoolClass = schoolClass(
//                id: String,
//                classNumber: Int,
//                className: String)
//        }
    }
    
    
    func finishedFetching(students: [Student]) {
        allStudents = students
        
        if selectedStudentNumber != nil {
            for student in allStudents {
                if student.studentNumber == selectedStudentNumber {
                    selectedStudent = student
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func finishedFetching(classesWithStudents: [(schoolClass: SchoolClass, students: [Student])]) {
        // no implementation needed in this class
    }
    
    
    
    
    // getStudentsForAccount
    func getStudentsForAccount() {
//        let accountNo = UserDefaults.standard.integer(forKey: Constants.LOGGED_IN_ACCOUNT_NUMBER_KEY)
//        if accountNo == 0 {
//            dataService.getAllStudents()
//        } else {
//           dataService.getStudents(for: schoolClass)
        
            
//            if let schoolClass = Data.getSchoolClass(numbered: UserDefaults.standard.integer(forKey: Constants.LOGGED_IN_ACCOUNT_NUMBER_KEY)) {
//                if let students = Data.getStudents(for: schoolClass) {
//                    allStudents = students
//                } else {
//                    // problem getting data
//                    print ("error getting class students for student seleection vc")
//                }
//            }
//        }
    }
    
    // Sets number of rows in the table of Students
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allStudents.isEmpty {
            return 0
        } else {
            return allStudents.count + 2
        }
    }

    
    // Configures cells in the table of Students
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // transparent cell used as padding at the top of the table
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTopPaddingCell", for: indexPath) as! TransparentCell
            cell.selectionStyle = .none
            return cell
        
            // transparent cell containing the 'OK' button as the last row in the table
        } else if indexPath.row == allStudents.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentOKButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
            // configure 'Student' cell for all other cells
        } else {
            let student = allStudents[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentCell
            cell.studentNameLabel.text = "\(student.firstName!) \(student.lastName!)"
            
                // update cell appearance according to whether the current cell corresponds to a potentially selected Student
            if selectedStudent == nil {
                cell.backgroundColor = UIColor.white
                cell.checkImage.image = nil
            } else {
                if selectedStudent! == student {
                    cell.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
                    cell.checkImage.image = UIImage(named: "check")
                } else {
                    cell.backgroundColor = UIColor.white
                    cell.checkImage.image = nil
                }
            }
            return cell
        }
    }
    
    
    // Updates current Student selection when corresponding cell is pressed. If the cell corresponding to the already selected student is pressed, it is deselected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 && indexPath.row != allStudents.count + 1 else { return }
        
        let student = allStudents[indexPath.row - 1]
        
        if selectedStudent == nil {
            selectedStudent = student
        } else {
            if selectedStudent == student {
                selectedStudent = nil
            } else {
               selectedStudent = student
            }
        }
        tableView.reloadData()
    }

    
    // Sets the height for cells in table of Students
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 0
        } else if indexPath.row == allStudents.count + 1 {
            return 125
        } else {
            return 80
        }
    }
    
    
    // Sets parent VC's 'Student' value to thic VC's selected value, before segueing back to parent VC. If no student is selected, an alert is shown to the user to prompt selection.
    @IBAction func okButtonPressed(_ sender: Any) {
        
            // if no student selected present alert
        guard selectedStudent != nil else {
            let alert = UIAlertController(title: "No Selection", message: "Please select a student", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
            // pass selected Student to delegate and segue back
        studentSelectionDelegate?.setStudent(to: selectedStudent!)
        self.navigationController?.popViewController(animated: true)
    }


}
