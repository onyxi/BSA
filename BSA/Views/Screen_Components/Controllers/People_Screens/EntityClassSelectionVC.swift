//
//  EntityClassSelectionVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 13/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

protocol EntityClassSelectionDelegate {
    func didSelect(schoolClass: SchoolClass)
}

class EntityClassSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SchoolClassFetchingDelegate {

    // UI handles:
    @IBOutlet weak var tableView: UITableView!
    
    // Properties:
    var allClasses = [SchoolClass]()
    var selectedClass: SchoolClass?
    var entityClassSelectionDelegate: EntityClassSelectionDelegate!
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()

            // set up table of School Classes
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        
        let dataService = DataService()
        dataService.schoolClassFetchingDelegate = self
        dataService.getAllSchoolClasses()
        
            // get School Class objects from storage and reload table
//        if let classes = Data.getAllSchoolClasses() {
//            allClasses = classes
//            tableView.reloadData()
//        } else {
//            // problem getting data
//            print ("error getting classes data for entity selection")
//        }
    }
    
    func finishedFetching(schoolClasses: [SchoolClass]) {
        allClasses = schoolClasses
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    // Sets number of rows in the table of School Classes
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allClasses.isEmpty {
            return 0
        } else {
            return allClasses.count + 2
        }
    }
    
    // Configures cells in the table of School Classes
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            // transparent cell used as padding at the top of the table
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EntityClassTopPaddingCell", for: indexPath) as! TransparentCell
            return cell
            
            // transparent cell containing the 'OK' button as the last row in the table
        } else if indexPath.row == allClasses.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EntityClassOKButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
        
            // configure cells for School Classes
        } else {
            let schoolClass = allClasses[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "EntityClassSelectionCell", for: indexPath) as! EntityClassSelectionCell
            cell.titleLabel.text = schoolClass.className
            
                // update cell appearance according to whether the current cell corresponds to a potentially selected School Class
            if selectedClass == nil {
                cell.backgroundColor = UIColor.white
                cell.accessoryType = .none
            } else if selectedClass == schoolClass {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
    }
    
    // Sets the height for cells in table of School Classes
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 10
        } else if indexPath.row == allClasses.count + 1 {
            return 125
        } else {
            return 80
        }
    }
    
    
    // Updates current Class selection when corresponding cell is pressed. If the cell corresponding to the already selected class is pressed, it is deselected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 && indexPath.row != allClasses.count + 1 else { return }
        
        let schoolClass = allClasses[indexPath.row - 1]
        
        if selectedClass == nil {
            selectedClass = schoolClass
        } else {
            if selectedClass == schoolClass {
                selectedClass = nil
            } else {
                selectedClass = schoolClass
            }
        }
        tableView.reloadData()
    }

    
    // Sets delegate VC's 'School Class' value to thic VC's selected School Class, before segueing back to parent VC. If no Class is selected, an alert is shown to the user to prompt selection.
    @IBAction func okButtonPressed(_ sender: Any) {
        
        // if no Class selected present alert
        guard selectedClass != nil else {
            let alert = UIAlertController(title: "No Selection", message: "Please select a class", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
            // pass selected School Class to delegate and segue back
        entityClassSelectionDelegate.didSelect(schoolClass: selectedClass!)
        self.navigationController?.popViewController(animated: true)
    }
    
   
}
