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
    var existingStaff = [Staff]()
    var staffMember: Staff?
    var id = NSUUID().uuidString
    var staffNumber: String?
    var firstName: String?
    var lastName: String?
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
        
            // initalise DataService
        dataService = DataService()
        
        // unpack Staff object if passed in from parent VC, reload table to include object data, and add 'Delete' button for presented object
        if staffMember != nil {
            id = staffMember!.id
            staffNumber = String(staffMember!.staffNumber)
            firstName = staffMember!.firstName
            lastName = staffMember!.lastName
            tableView.reloadData()
            addDeleteButton()
        }
    
            // add swipe-gesture recognisers to main view
        addGestureRecognisers()
    }
    
    // Adds right swipe-gesture recogniser to the main view
    func addGestureRecognisers() {
        
        // add right-swipe recogniser
        var swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(processGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    
    // Processes recognised right swipe recognisers
    @objc func processGesture(gesture: UIGestureRecognizer) {
        if let gesture = gesture as? UISwipeGestureRecognizer {
            switch gesture.direction {
                
            // navigate back to previous screen
            case UISwipeGestureRecognizerDirection.right:
                self.navigationController?.popViewController(animated: true)
                
            default:
                break
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    // Sets number of rows in the table of Staff Member details
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
        } else if indexPath.row == 4 {
            return 125
        } else {
            return 80
        }
    }
    
    
    // Adds a configured 'Delete' button to the navigation bar
    func addDeleteButton() {
        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(named: "deleteIcon"), for: .normal)
        deleteButton.setTitle(" Delete", for: .normal)
        deleteButton.sizeToFit()
        deleteButton.addTarget(self, action: #selector(self.deleteButtonPressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteButton)
    }
    
    // Checks to make sure user actually wants to delete the Staff object
    @objc func deleteButtonPressed() {
        let alert = UIAlertController(title: "Are you sure?", message: "Deleting a Staff Member cannot be undone", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.deleteStaff()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //  Triggers deletion of the presented entity - and unwinds to parent VC if successful
    func deleteStaff() {
        dataService!.delete(entity: self.staffMember, account: nil) { (success, errMsg) in
            if success {
                let alert = UIAlertController(title: "Staff Member Deleted", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Deletion Error", message: "Unable to delete Staff Member, please check your connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    // Sets the Staff object's 'First Name', 'Last Name' or 'Staff Number' value to the string sent from an edited text field - depending on the cell/textField that was edited by the user (identified using the cell's tag).
    func textFieldChanged(to value: String, for cellTag: Int) {
       
        switch cellTag {
            
        case 1: // Staff Number field edited
            staffNumber = value
            
        case 2: // First Name field edited
            firstName = value
        
        case 3: // Last Name field edited
            lastName = value
            
        default : break
        }
    }
    
    
    // Saves changes to Staff object details and unwinds to parent VC (first checking to make sure that required values have been given)
    @IBAction func saveChangesButtonPressed(_ sender: Any) {
        
        // makue sure a staff number has been given. If not, present alert to prompt name entry
        guard staffNumber != nil && staffNumber != "" else {
            let alert = UIAlertController(title: "No Staff Number Given", message: "Please enter a unique number for the Staff Member", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // make sure the staff number is a valid integer value
        guard let staffNumberIntValue = Int(staffNumber!) else {
            print ("invalid staff number")
            let alert = UIAlertController(title: "Invalid Staff Number", message: "Please enter numeric integer values only for the Staff Number", preferredStyle: UIAlertControllerStyle.alert)
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
        
            //  package Staff object
        let updatedStaffMember = Staff(id: self.id, staffNumber: Int(self.staffNumber!)!, firstName: self.firstName!, lastName: self.lastName!)
        
            // save obejct to database
        dataService?.createStaffMember(staffMember: updatedStaffMember, completion: { (staffID, staffName) in
            if staffID != nil {
                print ("Created Staff Member: \(staffName)")
                
                // alert user if problem with upload
            } else {
                let alert = UIAlertController(title: "Error Creating Staff Member", message: "Please check your connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        })
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
}
