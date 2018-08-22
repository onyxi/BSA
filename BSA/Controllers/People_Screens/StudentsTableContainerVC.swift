//
//  StudentsTableContainerVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 12/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows a selected Student object to be sent to the delegate
protocol StudentEntitySelectionDelegate {
    func didFetchAll(students: [Student])
    func selectAndShowDetailsFor(student: Student)
}

class StudentsTableContainerVC: UITableViewController, EntitySelectionDelegate, StudentFetchingDelegate {
    
    // Properties:
    var allStudents = [Student]()
    var studentEntitySelectionDelegate: StudentEntitySelectionDelegate!
    var dataService: DataService!
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // setup table of Students
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        
        
            // initialise DataService and request all Student objects
        dataService = DataService()
        dataService.studentFetchingDelegate = self
        dataService.getAllStudents()
        
    }
    
    // Requests all Student objects every time the view is displayed
    override func viewDidAppear(_ animated: Bool) {
        dataService?.getAllStudents()
    }
    
    // Assigns fetched Student objects to class-level scope and reload table to be populated with fetched data
    func finishedFetching(students: [Student]) {
        allStudents = students
        studentEntitySelectionDelegate.didFetchAll(students: students)
        tableView.reloadData()
    }
    

    // Sends a Student object to the delegate - from the array of all Student objects and corresponding to the cell that the user has pressed
    func selectEntity(at index: Int) {
        studentEntitySelectionDelegate.selectAndShowDetailsFor(student: allStudents[index])
    }


    // MARK: - Table view data source
    
    // Sets number of rows in the table of Students
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allStudents.isEmpty {
            return 0
        } else {
            return allStudents.count + 1
        }
    }

    // Configures cells in the table of Students
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // transparent cell used as padding at the top of the table
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleStudentTopPaddingCell", for: indexPath)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
            // configure 'People Student' cell for all other cells
        } else {
            let student = allStudents[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleStudentCell", for: indexPath) as! PeopleStudentCell
            cell.studentNameLabel.text = "\(student.firstName!) \(student.lastName!)"
            cell.entitySelectionDelegate = self
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            
            return cell
        }
    }
    
    // Sets the height for cells in table of Students
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 10
        }
        return 90
    }


    func finishedFetching(classesWithStudents: [(schoolClass: SchoolClass, students: [Student])]) {
        // needed to confrom to protocol - no implementation needed in this class
    }
    
}
