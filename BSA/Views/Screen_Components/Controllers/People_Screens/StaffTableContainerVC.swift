//
//  StaffTableContainerVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 12/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows a selected Staff object to be sent to the delegate
protocol StaffEntitySelectionDelegate {
    func selectAndShowDetailsFor(staff: Staff)
}

class StaffTableContainerVC: UITableViewController, EntitySelectionDelegate, StaffFetchingDelegate {
 
    
    
    // Properties:
    var allStaff = [Staff]()
    var staffEntitySelectionDelegate: StaffEntitySelectionDelegate!
    
    var dataService: DataService?
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()

            // setup table of Staff
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        
        dataService = DataService()
        dataService?.staffFetchingDelegate = self
        dataService?.getAllStaffMembers()
        
            // get Staff data from storage and reload table
//        if let staff = Data.getAllStaffMembers() {
//            allStaff = staff
//            tableView.reloadData()
//        } else {
//            // problem getting data
//            print ("error getting staff data for staff selection VC")
//        }
    }
    
    
    func finishedFetching(staffMembers: [Staff]) {
        allStaff = staffMembers
        tableView.reloadData()
    }
    

    // Sends a Staff object to the delegate - from the array of all Staff objects and corresponding to the cell that the user has pressed
    func selectEntity(at index: Int) {
        staffEntitySelectionDelegate.selectAndShowDetailsFor(staff: allStaff[index])
    }
    


    // MARK: - Table view data source
    
    // Sets number of rows in the table of Staff
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allStaff.isEmpty {
            return 0
        } else {
            return allStaff.count + 1
        }
    }

    // Configures cells in the table of Staff
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // transparent cell used as padding at the top of the table
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleStaffTopPaddingCell", for: indexPath)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
            // configure 'People Staff' cell for all other cells
        } else {
            let staffMember = allStaff[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleStaffCell", for: indexPath) as! PeopleStaffCell
            cell.staffNameLabel.text = "\(staffMember.firstName!) \(staffMember.lastName!)"
            cell.entitySelectionDelegate = self
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            
            return cell
        }
    }
    
    // Sets the height for cells in table of Staff
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 10
        }
        return 90
    }

   

}
