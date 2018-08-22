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
    var userAccount: UserAccount?
    var schoolClass: SchoolClass?
    var id = NSUUID().uuidString
    var className: String?
    var dataService: DataService!
    var password: String?
    
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
            className = schoolClass!.className
            tableView.reloadData()
            addDeleteButton()
        }
        
            // unpack user-account object associated with school class
        if userAccount != nil {
            password = userAccount?.password
        }
        
            // initialise DataService
        dataService = DataService()
    
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
            
            // configure cell for School Class' Name
        } else if indexPath.row == 1 {
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
            
            // configure cell for School Class' account password
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDetailsTextFieldCell", for: indexPath) as! EntityDetailsTextFieldCell
            cell.titleLabel.text = "Password"
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            cell.entityDetailsTextFieldDelegate = self
            cell.tag = indexPath.row
            
            // if a School Class object was passed in from parent VC, update cell with that object's value
            if password != nil {
                cell.valueTextField.text = password!
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
        deleteButton.setTitle(" Delete", for: .normal)
        deleteButton.sizeToFit()
        deleteButton.addTarget(self, action: #selector(self.deleteButtonPressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteButton)
    }
    
    // Checks to make sure user actually wants to delete the Class object
    @objc func deleteButtonPressed() {
        let alert = UIAlertController(title: "Are you sure?", message: "Deleting a Class cannot be undone", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.deleteClass()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Triggers deletion of the presented entity - and unwinds to parent VC if successful
    func deleteClass(){
        dataService.delete(entity: self.schoolClass, account: self.userAccount) { (success, errMsg) in
            if success {
                let alert = UIAlertController(title: "School Class Deleted", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Deletion Error", message: "Unable to delete School Class, please check your connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    // Sets the School Class object's 'Class Number' or 'Class Name' value to the string sent from an edited text field - depending on the cell/textField that was edited by the user (identified using the cell's tag).
    func textFieldChanged(to value: String, for cellTag: Int) {
        if cellTag == 1 {
            className = value
        } else if cellTag == 2 {
            password = value
        }
    }


    // Saves changes to School Class object details and unwinds to parent VC (first checking to make sure that required values have been given)
    @IBAction func saveChangesButtonPressed(_ sender: Any) {
        
        // makue sure a Class Name has been given. If not, present alert to prompt name entry
        guard className != nil && className != "" else {
            let alert = UIAlertController(title: "No Class Name Given", message: "Please enter a name for the Class", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard password != nil && password != "" else {
            let alert = UIAlertController(title: "No Password Given", message: "Please enter a password for the Class Account", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // save changes to storage and unwind to parent VC
        
            //  package School Class object
        let updatedSchoolClass = SchoolClass(id: self.id, className: self.className!)
        
            // save obejct to database
        dataService.createSchoolClass(schoolClass: updatedSchoolClass) { (schoolClassID, schoolClassName) in
            if schoolClassID != nil {
                print ("Created School-Class: \(schoolClassName)")
            
                // alert user if problem with upload
            } else {
                let alert = UIAlertController(title: "Error Creating Class", message: "Please check your connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }

            // create new associated User Account
        let userAccountToSave = UserAccount(
            id: userAccount != nil ? userAccount!.id : Constants.getUniqueId(),
            accountName: updatedSchoolClass.className,
            securityLevel: 1,
            schoolClassId: updatedSchoolClass.id,
            password: self.password!)
        dataService.createUserAccount(userAccount: userAccountToSave, completion: { (success, message) in
            if success {
               // account created
                print(message)
            } else {
                // account creation failed
                print(message)
            }
        })
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
