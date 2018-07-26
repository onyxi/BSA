//
//  ClassDetailsVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 14/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class ClassDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, EntityDetailsTextFieldDelegate {

    // UI handles:
    @IBOutlet weak var tableView: MaterialTableView!
    
    
    // Properties:
    var schoolClass: SchoolClass?
    var id = NSUUID().uuidString
//    var classNumber: Int?
    var className: String?
//    var classStudents: [Int]?
    
    // Configures view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // set VC color and title
        view.layer.backgroundColor = Constants.PEOPLE_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Class Details"

            // set up table for School Class details
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        
            // unpack SchoolClass object if passed in from parent VC, reload table to include object data, and add 'Delete' button for presented object
        if schoolClass != nil {
            id = schoolClass!.id
//            classNumber = schoolClass?.classNumber
            className = schoolClass!.className
//            classStudents = schoolClass?.classStudents
            tableView.reloadData()
            addDeleteButton()
        }
    }
    
    
    // MARK: - Table view data source
    
    // Sets number of rows in the table of School Class details
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    // Configures cells in the table of School Class details
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // transparent cell used as padding at the top of the table
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDetailsTopPaddingCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
            // configure cell for School Class Number
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDetailsTextFieldCell", for: indexPath) as! EntityDetailsTextFieldCell
            cell.titleLabel.text = "Class Number"
            cell.selectionStyle = .none
            cell.entityDetailsTextFieldDelegate = self
            cell.tag = indexPath.row
            
            // if a School Class object was passed in from parent VC, update cell with that object's value
//            if classNumber != nil {
//                cell.valueTextField.text = String(classNumber!)
//            }
            
            return cell
            
            // configure cell for School Class' Name
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDetailsTextFieldCell", for: indexPath) as! EntityDetailsTextFieldCell
            cell.titleLabel.text = "Class Name"
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            cell.entityDetailsTextFieldDelegate = self
            cell.tag = indexPath.row
            
                // if a School Class object was passed in from parent VC, update cell with that object's value
            if className != nil {
                cell.valueTextField.text = className!
            }
            
            return cell
            
            // transparent cell containing the 'Save Changes' button as the last row in the table
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDetailsSaveChangesButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    // Sets the height for cells in table of School Class details
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 10
        } else if indexPath.row == 3 {
            return 125
        } else {
            return 80
        }
    }
    
    
    // Adds a configured 'Delete' button to the navigation bar
    func addDeleteButton() {
        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(named: "deleteIcon"), for: .normal)
        deleteButton.sizeToFit()
        deleteButton.addTarget(self, action: #selector(self.deleteButtonPressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteButton)
    }
    
    //  Triggers deletion of the presented entity - and unwinds to parent VC if successful
    @objc func deleteButtonPressed() {
        print("Deleting Class: \n\(String(describing: schoolClass!))")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // Sets the School Class object's 'Class Number' or 'Class Name' value to the string sent from an edited text field - depending on the cell/textField that was edited by the user (identified using the cell's tag).
    func textFieldChanged(to value: String, for cellTag: Int) {
        className = value
//        switch cellTag {
//
//        case 1: // Class Number field edited
//            if let classNumberIntValue = Int(value) {
//                classNumber = classNumberIntValue
//            } else {
//                print ("invalid class number")
//            }
//        case 2: // Class Name field edited
//            className = value
//
//        default : break
//        }
    }


    // Saves changes to School Class object details and unwinds to parent VC (first checking to make sure that required values have been given)
    @IBAction func saveChangesButtonPressed(_ sender: Any) {

        // makue sure a Class Number has been given. If not, present alert to prompt name entry
//        guard classNumber != nil else {
//            let alert = UIAlertController(title: "No Class Number Given", message: "Please enter a unique number for the Class", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                alert.dismiss(animated: true, completion: nil)
//            }))
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
        
        // makue sure a Class Name has been given. If not, present alert to prompt name entry
        guard className != nil && className != "" else {
            let alert = UIAlertController(title: "No Class Name Given", message: "Please enter a name for the Class", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // save changes to storage and unwind to parent VC
        
            //  package School Class object and save changes here...
        let updatedSchoolClass = SchoolClass(id: self.id, className: self.className!)
//            SchoolClass(id: self.id, classNumber: self.classNumber!, className: self.className!, classStudents: self.classStudents)
        
        print (updatedSchoolClass)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
