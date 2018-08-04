//
//  PeopleVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 11/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class PeopleVC: UIViewController, ClassEntitySelectionDelegate, StaffEntitySelectionDelegate, StudentEntitySelectionDelegate {
    
    // UI handles:
    @IBOutlet weak var subtitleBarLabelMain: SubtitleLabel!
    @IBOutlet weak var subtitleBarLabelLeft: SubtitleLabel!
    @IBOutlet weak var subtitleBarArrowLeft: SubtitleBarArrowLeft!
    @IBOutlet weak var subtitleBarLabelRight: SubtitleLabel!
    @IBOutlet weak var subtitleBarArrowRight: SubtitleBarArrowRight!
    @IBOutlet weak var subtitleBarButtonLeft: UIButton!
    @IBOutlet weak var subtitleBarButtonRight: UIButton!
    @IBOutlet weak var classesTableXAlign: NSLayoutConstraint!
    @IBOutlet weak var staffTableXAlign: NSLayoutConstraint!
    @IBOutlet weak var studentsTableXAlign: NSLayoutConstraint!
    
    
    // Properties
    var classesTableAnimation: AnimationEngine!
    var staffTableAnimation: AnimationEngine!
    var studentsTableAnimation: AnimationEngine!
    
    var currentShowingEntitySet: EntitySet = .classes
    var entitySetToShowDetailsFor: EntitySet!

    var selectedClass: SchoolClass?
    var selectedStaff: Staff?
    var selectedStudent: Student?
    
    
    // Configures view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // set VC color and title, and add logout button
        view.layer.backgroundColor = Constants.PEOPLE_SCREEN_COLOR.cgColor
        self.navigationItem.title = "People"
        addLogoutButton()
        addNewEntityButton()
        setupSubtitleLabels()
        
            // initialise Animation Engines for table view containers and set initial positions
        setupTableViews()
    }
    
    
    // Initialises Animation Engines for table view containers and sets initial positions
    func setupTableViews() {
        classesTableAnimation = AnimationEngine(layoutConstraints: [classesTableXAlign])
        staffTableAnimation = AnimationEngine(layoutConstraints: [staffTableXAlign])
        studentsTableAnimation = AnimationEngine(layoutConstraints: [studentsTableXAlign])
        
        staffTableAnimation.setOffScreenRight()
        studentsTableAnimation.setOffScreenRight()
    }
    
    // Sets the selection of SchoolClass object in response to user selecting a corresponding cell and prepares to show details for that SchoolClass object
    func selectAndShowDetailsFor(schoolClass: SchoolClass){
        selectedClass = schoolClass
        showDetails(for: schoolClass)
    }
    
    // Sets the selection of Staff object in response to user selecting a corresponding cell and prepares to show details for that Staff object
    func selectAndShowDetailsFor(staff: Staff){
        selectedStaff = staff
        showDetails(for: staff)
    }
    
    // Sets the selection of Student object in response to user selecting a corresponding cell and prepares to show details for that Student object
    func selectAndShowDetailsFor(student: Student){
        selectedStudent = student
        showDetails(for: student)
    }
    
    // Triggers segue to an Entity Details screen of the type selected - passing in the selected 'entity' to show the details of
    func showDetails(for entity: Any?) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch currentShowingEntitySet {
            
            // if a School Class cell/object has been selected, segue to Class Details VC
        case .classes:
            let classDetailsVC = storyboard.instantiateViewController(withIdentifier: "ClassDetailsVC") as! ClassDetailsVC
            
                // if showing details for existing entity, pass object to destination VC, otherwise show empty form
            if entity != nil {
                classDetailsVC.schoolClass = entity as? SchoolClass
            }
            
            classDetailsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(classDetailsVC, animated: true)
            
            // if a Staff cell/object has been selected, segue to Staff Details VC
        case .staff:
            let staffDetailsVC = storyboard.instantiateViewController(withIdentifier: "StaffDetailsVC") as! StaffDetailsVC
            
                // if showing details for existing entity, pass object to destination VC, otherwise show empty form
            if entity != nil {
                staffDetailsVC.staffMember = entity as? Staff
            }
            
            staffDetailsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(staffDetailsVC, animated: true)
            
            // if a Students cell/object has been selected, segue to Student Details VC
        case .students:
            let studentDetailsVC = storyboard.instantiateViewController(withIdentifier: "StudentDetailsVC") as! StudentDetailsVC
            
                // if showing details for existing entity, pass object to destination VC, otherwise show empty form
            if entity != nil {
                studentDetailsVC.student = entity as? Student
            }
            
            studentDetailsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(studentDetailsVC, animated: true)
            
        }
    }
    
    
    // Sets the the current view controller as delegates for each of the 3 table container views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showClassesEntityContainerSegue" {
            let destinationVC = segue.destination as! ClassesTableContainerVC
            destinationVC.classEntitySelectionDelegate = self
        } else if segue.identifier == "showStaffEntityContainerSegue" {
            let destinationVC = segue.destination as! StaffTableContainerVC
            destinationVC.staffEntitySelectionDelegate = self
        } else if segue.identifier == "showStudentEntityContainerSegue" {
            let destinationVC = segue.destination as! StudentsTableContainerVC
            destinationVC.studentEntitySelectionDelegate = self
        }
    }
    

    // Animates container views to the right - to give feeling of user browsing/scrolling to the left
    @IBAction func leftSubtitleButtonPressed(_ sender: Any) {
        
            // only allow user to scroll as far as the 'Classes' container view, and disable the button momentarily to avoid multiple presses
        guard currentShowingEntitySet != .classes else { return }
        subtitleBarButtonLeft.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.subtitleBarButtonLeft.isEnabled = true })
        
        subtitleBarLabelLeft.flash(to: Constants.BLUE)
        
        switch currentShowingEntitySet {
        case .students:
            currentShowingEntitySet = .staff
            subtitleBarLabelMain.text = "Staff"
            subtitleBarLabelLeft.text = "Classes"
            subtitleBarLabelRight.show()
            subtitleBarLabelRight.text = "Students"
            subtitleBarArrowRight.show()
            subtitleBarButtonRight.isEnabled = true
            
            studentsTableAnimation.animateOffScreenRight()
            staffTableAnimation.animateOnFromScreenLeft()
        case .staff:
            currentShowingEntitySet = .classes
            subtitleBarLabelMain.text = "Classes"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.subtitleBarLabelLeft.hide() })
            subtitleBarArrowLeft.hide()
            subtitleBarLabelRight.text = "Staff"
            
            staffTableAnimation.animateOffScreenRight()
            classesTableAnimation.animateOnFromScreenLeft()
        case .classes:
            break
        }
    }
    
    // Animates container views to the left - to give feeling of user browsing/scrolling to the right
    @IBAction func rightSubtitleButtonPressed(_ sender: Any) {
        
            // only allow user to scroll as far as the 'Classes' container view, and disable the button momentarily to avoid multiple presses
        guard currentShowingEntitySet != .students else { return }
        subtitleBarButtonRight.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.subtitleBarButtonRight.isEnabled = true })
        
        subtitleBarLabelRight.flash(to: Constants.BLUE)
        
        switch currentShowingEntitySet {
        case .classes:
            subtitleBarLabelRight.flash(to: Constants.BLUE)
            currentShowingEntitySet = .staff
            subtitleBarLabelMain.text = "Staff"
            subtitleBarLabelRight.text = "Students"
            subtitleBarLabelLeft.show()
            subtitleBarLabelLeft.text = "Classes"
            subtitleBarArrowLeft.show()
            subtitleBarButtonLeft.isEnabled = true
            
            classesTableAnimation.animateOffScreenLeft()
            staffTableAnimation.animateOnFromScreenRight()
        case .staff:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.subtitleBarLabelRight.hide() })
            currentShowingEntitySet = .students
            subtitleBarLabelMain.text = "Students"
            subtitleBarArrowRight.hide()
            subtitleBarLabelLeft.text = "Staff"
            
            staffTableAnimation.animateOffScreenLeft()
            studentsTableAnimation.animateOnFromScreenRight()
        case .students:
            break
        }
    }
    
    
    // Adds a configured 'New Entity' button to the navigation bar
    func addNewEntityButton() {
        let newEntityButton = UIButton(type: .system)
        newEntityButton.setImage(UIImage(named: "plusIcon"), for: .normal)
        newEntityButton.sizeToFit()
        newEntityButton.addTarget(self, action: #selector(self.newEntityButtonPressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: newEntityButton)
    }
    
    //  Triggers segue to an empty Entity Details VC - according to the entity type (current container view) being show
    @objc func newEntityButtonPressed() {
        // got to appropriate new entity screen - with blank form for completion
        showDetails(for: nil)
    }
    
    // Sets up the subtitle labels' initial appearances and values
    func setupSubtitleLabels() {
        subtitleBarLabelMain.textColor = Constants.BLACK
        subtitleBarLabelMain.text = "Classes"
        
        subtitleBarLabelLeft.textColor = Constants.BLUE
        subtitleBarLabelLeft.hide()
        subtitleBarArrowLeft.hide()
        
        subtitleBarLabelRight.textColor = Constants.BLUE
        subtitleBarLabelRight.text = "Staff"
        subtitleBarArrowRight.enable()
    }

    // Adds a configured logout button to the navigation bar
    func addLogoutButton() {
        let logoutButton = UIButton(type: .system)
        logoutButton.setImage(UIImage(named: "logoutButton"), for: .normal)
        logoutButton.setTitle("  Log-Out", for: .normal)
        logoutButton.sizeToFit()
        logoutButton.addTarget(self, action: #selector(self.logoutButtonPressed), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
    }

    // Logs out the user and segue's to the app's initial login screen
    @objc func logoutButtonPressed() {
        
        // present alert to make sure the user want to actually wants to log out
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        } ))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                // remove record of logged in account and segue to login screen
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_ID)
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_NAME)
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_SECURITY_LEVEL)
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_CLASS_ID)
            self.performSegue(withIdentifier: "unwindPeopleVCToLoginVCSegue", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}

// Provide constrained values for different available types of entity
enum EntitySet: String {
    case classes
    case staff
    case students
}
