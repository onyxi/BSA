//
//  StaffDetailsVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 14/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class StaffDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, EntityDetailsTextFieldDelegate {
//, ShowEntityClassSelectionDelegate, EntityClassSelectionDelegate {

    
    // UI handles:
    @IBOutlet weak var tableView: MaterialTableView!
    
    //Properties:
    var staffMember: Staff?
    var id = NSUUID().uuidString
    var staffNumber: Int?
    var firstName: String?
    var lastName: String?
//    var schoolClassNumber: Int?
//    var schoolClassId: String?
//    var schoolClass: SchoolClass?
    var schoolClassName: String?
    
    var dataService: DataService?

    // Configures view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // set VC color and title
        view.layer.backgroundColor = Constants.PEOPLE_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Staff Member Details"
        
            // set up table for Staff Member details
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        
        dataService = DataService()
//        dataService?.schoolClassFetchingDelegate = self
        
        // unpack Staff object if passed in from parent VC, reload table to include object data, and add 'Delete' button for presented object
        if staffMember != nil {
            id = staffMember!.id
            staffNumber = staffMember!.staffNumber
            firstName = staffMember!.firstName
            lastName = staffMember!.lastName
//            schoolClassNumber = staffMember?.schoolClassNumber
//            schoolClassId = staffMember.
//            schoolClassName = Data.getSchoolClass(numbered: schoolClassNumber)?.className
            tableView.reloadData()
            addDeleteButton()
        }
    }
    
    
    // MARK: - Table view data source
    
    // Sets number of rows in the table of Staff Member details
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    // Configures cells in the table of Staff Member details
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // transparent cell used as padding at the top of the table
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaffDetailsTopPaddingCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
            // configure cell for staff details Staff Number
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaffDetailsTextFieldCell", for: indexPath) as! EntityDetailsTextFieldCell
            cell.titleLabel.text = "Staff Number"
            cell.selectionStyle = .none
            cell.entityDetailsTextFieldDelegate = self
            cell.tag = indexPath.row
            
            // if a Staff object was passed in from parent VC, update cell with that object's value
            if staffNumber != nil {
                cell.valueTextField.text = String(staffNumber!)
            }
            
            return cell
            
            // configure cell for staff details First Name
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaffDetailsTextFieldCell", for: indexPath) as! EntityDetailsTextFieldCell
            cell.titleLabel.text = "First Name"
            cell.selectionStyle = .none
            cell.entityDetailsTextFieldDelegate = self
            cell.tag = indexPath.row
            
                // if a Staff object was passed in from parent VC, update cell with that object's value
            if firstName != nil {
                cell.valueTextField.text = firstName!
            }
            
            return cell
            
            // configure cell for staff details Last Name
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaffDetailsTextFieldCell", for: indexPath) as! EntityDetailsTextFieldCell
            cell.titleLabel.text = "Last Name"
            cell.selectionStyle = .none
            cell.entityDetailsTextFieldDelegate = self
            cell.tag = indexPath.row
            
                // if a Staff object was passed in from parent VC, update cell with that object's value
            if lastName != nil {
                cell.valueTextField.text = lastName!
            }
            
            return cell
            
            // configure cell for staff details Class
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaffDetailsSelectionCell", for: indexPath) as! EntityDetailsSelectionCell
            cell.titleLabel.text = "Class"
            cell.valueLabel.text = "Please select..."
            cell.valueLabel.textColor = Constants.GRAY_LIGHT
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
//            cell.showEntityClassSelectionDelegate = self
            
                // if a Staff object was passed in from parent VC, update cell with that object's value
//            if schoolClassName != nil {
//                cell.valueLabel.text = schoolClassName!
//                cell.valueLabel.textColor = .black
//            }
            
            return cell
            
            // transparent cell containing the 'Save Changes' button as the last row in the table
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaffDetailsSaveChangesButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    // Sets the height for cells in table of Staff details
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 10
        } else if indexPath.row == 5 {
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
        print("Deleting Staff Member: \n\(String(describing: staffMember!))")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    // Sets the Staff object's 'First Name', 'Last Name' or 'Staff Number' value to the string sent from an edited text field - depending on the cell/textField that was edited by the user (identified using the cell's tag).
    func textFieldChanged(to value: String, for cellTag: Int) {
       
        switch cellTag {
            
        case 1: // Staff Number field edited
            if let staffNumberIntValue = Int(value) {
                staffNumber = staffNumberIntValue
            } else {
                print ("invalid staff number")
            }
        case 2: // First Name field edited
            firstName = value
        
        case 3: // Last Name field edited
            lastName = value
            
        default : break
        }
    }
    
    // Sets the Staff object's schoolClass value to the SchoolClass object sent from a delegated EntityClassSelectionVC. Useful properties (schoolClassNumber and schoolClassName) are also unpacked for convenient use in table values - before reloading the table of Staff details
//    func didSelect(schoolClass: SchoolClass) {
////        self.schoolClass = schoolClass
////        schoolClassNumber = schoolClass.classNumber
////        schoolClassName = schoolClass.className
////        tableView.reloadData()
//    }
//
//    // Initiates segue to VC for selecting a class object to assign to the Staff member. Trigger when the user presses the 'Class' cell in the staff details table
//    func showClassSelection() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let staffClassSelectionVC = storyboard.instantiateViewController(withIdentifier: "EntityClassSelectionVC") as! EntityClassSelectionVC
//        staffClassSelectionVC.entityClassSelectionDelegate = self
//
//            // if a schoolClass object has already been assigned to the Staff object, pass to the destination/selection VC so that current seletion can be displayed
//        if schoolClass != nil {
//            staffClassSelectionVC.selectedClass = schoolClass
//        }
//
//            // perform segue
//        self.navigationController?.pushViewController(staffClassSelectionVC, animated: true)
//    }
    

    
    // Saves changes to Staff object details and unwinds to parent VC (first checking to make sure that required values have been given)
    @IBAction func saveChangesButtonPressed(_ sender: Any) {
        
        // makue sure a staff number has been given. If not, present alert to prompt name entry
        guard staffNumber != nil else {
            let alert = UIAlertController(title: "No Staff Number Given", message: "Please enter a unique number for the Staff Member", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //------
        
        // makue sure a first name has been given. If not, present alert to prompt name entry
        guard firstName != nil && firstName != "" else {
            let alert = UIAlertController(title: "No First Name Given", message: "Please enter a First Name for the Staff Member", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //------
        
        // makue sure a last name has been given. If not, present alert to prompt name entry
        guard lastName != nil && lastName != "" else {
            let alert = UIAlertController(title: "No Last Name Given", message: "Please enter a Last Name for the Staff Member", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    
        // save changes to storage and unwind to parent VC
        
            //  package Staff object and save changes here...
        let updatedStaffMember = Staff(id: self.id, staffNumber: self.staffNumber!, firstName: self.firstName!, lastName: self.lastName!)
//            Staff(id: self.id, staffNumber: self.staffNumber!, firstName: self.firstName!, lastName: self.lastName!, schoolClassNumber: self.schoolClassNumber)
        
        print (updatedStaffMember)
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
}
