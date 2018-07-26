//
//  ClassesTableContainerVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 12/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows a selected SchoolClass object to be sent to the delegate
protocol ClassEntitySelectionDelegate {
    func selectAndShowDetailsFor(schoolClass: SchoolClass)
}

class ClassesTableContainerVC: UITableViewController, EntitySelectionDelegate, SchoolClassFetchingDelegate {
    
    // Properties:
    var allClasses = [SchoolClass]()
    var classEntitySelectionDelegate: ClassEntitySelectionDelegate!
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()

            // setup table of School Classes
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()

            // get Class data from storage and reload table
        let dataService = DataService()
        dataService.schoolClassFetchingDelegate = self
        dataService.getAllSchoolClasses()
        
//        if let schoolClasses = DataService.getAllSchoolClasses() {
//
//        } else {
//            // problem getting data
//            print ("error getting school classes")
//        }
        
    }
    
    
    func finishedFetching(schoolClasses: [SchoolClass]) {
        allClasses = schoolClasses
        tableView.reloadData()
    }


    // Sends a SchoolClass object to the delegate - from the array of all SchoolClass objects and corresponding to the cell that the user has pressed
    func selectEntity(at index: Int) {
        classEntitySelectionDelegate.selectAndShowDetailsFor(schoolClass: allClasses[index])
    }
    

    // MARK: - Table view data source
    
    // Sets number of rows in the table of School Classes
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allClasses.isEmpty {
            return 0
        } else {
            return allClasses.count + 1
        }
    }

    // Configures cells in the table of School Classes
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // transparent cell used as padding at the top of the table
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleClassTopPaddingCell", for: indexPath)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
            // configure 'People Class' cell for all other cells
        } else {
            let schoolClass = allClasses[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleClassCell", for: indexPath) as! PeopleClassCell
            cell.classNameLabel.text = schoolClass.className
            cell.entitySelectionDelegate = self
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            
            return cell
        }
    }
    
    // Sets the height for cells in table of School Classes
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 10
        }
        return 90
    }
    

}
