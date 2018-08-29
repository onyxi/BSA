//
//  PeopleVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 11/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class PeopleVC: UIViewController, UserAccountFetchingDelegate, ClassEntitySelectionDelegate, StaffEntitySelectionDelegate, StudentEntitySelectionDelegate {
    
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
    
    @IBOutlet weak var activityIndicatorBackground: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var blurEffectView: UIView?
    
    // Properties
    var classesTableAnimation: AnimationEngine!
    var staffTableAnimation: AnimationEngine!
    var studentsTableAnimation: AnimationEngine!
    
    var currentShowingEntitySet: EntitySet = .classes
    var entitySetToShowDetailsFor: EntitySet!

    var dataService: DataService?
    
    var allSchoolClasses = [SchoolClass]()
    var selectedClass: SchoolClass?
    var allStaff = [Staff]()
    var selectedStaff: Staff?
    var allStudents = [Student]()
    var selectedStudent: Student?
    
    var userAccounts: [UserAccount]?
    
    var connectionTimer: Timer!
    
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
    
            // add swipe-gesture recognisers to main view
        addGestureRecognisers()
        
            // add blur while data loads
        setupActivityIndicator()
        
            // get all user-account objects from storage
        dataService = DataService()
        dataService?.userAccountFetchingDelegate = self
        dataService?.getAllUserAccounts()
    
        // add timer for connection time-out
        connectionTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(showConnectionTimeOutAlert), userInfo: nil, repeats: false)
    }
    
    @objc func showConnectionTimeOutAlert() {
        let alert = UIAlertController(title: "Network Error", message: "Please check your network connection", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//            self.connectionTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.showConnectionTimeOutAlert), userInfo: nil, repeats: false)
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // refresh data from storage
    override func viewWillAppear(_ animated: Bool) {
        dataService?.getAllUserAccounts()
    }
    
    // Assigns local reference to user-account objects fetched from storage
    func finishedFetching(userAccounts: [UserAccount]) {
        self.userAccounts = userAccounts
    }
    
    // Adds screen-blur and activity indicator while data is loading
    func setupActivityIndicator() {
        activityIndicatorBackground.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView!.frame = activityIndicatorBackground.bounds
        blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activityIndicatorBackground.addSubview(blurEffectView!)
        
        activityIndicatorBackground.bringSubview(toFront: activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    
    // Adds left / right swipe-gesture recognisers to the main view
    func addGestureRecognisers() {
        
        // add left-swipe recogniser
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(processGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        // add right-swipe recogniser
        var swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(processGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    
    // Processes recognised left/right swipe recognisers
    @objc func processGesture(gesture: UIGestureRecognizer) {
        if let gesture = gesture as? UISwipeGestureRecognizer {
            switch gesture.direction {
                
            // triggers navigation back to login screen (which first checks to make sure selection has been made)
            case UISwipeGestureRecognizerDirection.right:
                leftSubtitleButtonPressed(gesture)
                
            // navigates to account-selection screen
            case UISwipeGestureRecognizerDirection.left:
                rightSubtitleButtonPressed(gesture)
            default:
                break
            }
        }
    }
    
    
    // Initialises Animation Engines for table view containers and sets initial positions
    func setupTableViews() {
        classesTableAnimation = AnimationEngine(layoutConstraints: [classesTableXAlign])
        staffTableAnimation = AnimationEngine(layoutConstraints: [staffTableXAlign])
        studentsTableAnimation = AnimationEngine(layoutConstraints: [studentsTableXAlign])
        
        staffTableAnimation.setOffScreenRight()
        studentsTableAnimation.setOffScreenRight()
    }
    
    // Assigns local reference to all fetched School Class objects
    func didFetchAll(schoolClasses: [SchoolClass]) {
        
        // hide activity indicator ow that data has loaded
        activityIndicator.stopAnimating()
        connectionTimer.invalidate()
        UIView.animate(withDuration: 0.2, animations: {
            self.blurEffectView!.alpha = 0.0
        }) { (nil) in
            self.activityIndicatorBackground.isHidden = true
            self.activityIndicator.isHidden = true
        }
        
        allSchoolClasses = schoolClasses
    }
    
    // Sets the selection of SchoolClass object in response to user selecting a corresponding cell and prepares to show details for that SchoolClass object
    func selectAndShowDetailsFor(schoolClass: SchoolClass){
        selectedClass = schoolClass
        showDetails(for: schoolClass)
    }
    
    // Assigns local reference to all fetched Staff objects
    func didFetchAll(staff: [Staff]) {
        allStaff = staff
    }
    
    // Sets the selection of Staff object in response to user selecting a corresponding cell and prepares to show details for that Staff object
    func selectAndShowDetailsFor(staff: Staff){
        selectedStaff = staff
        showDetails(for: staff)
    }
    
    // Assigns local reference to all fetched Student objects
    func didFetchAll(students: [Student]) {
        allStudents = students
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
                let schoolClass = entity as? SchoolClass
              
                classDetailsVC.schoolClass = schoolClass
                
                if userAccounts != nil {
                    for account in userAccounts! {
                        if account.schoolClassId == schoolClass?.id {
                            classDetailsVC.userAccount = account
                        }
                    }
                } else {
                    // no accounts fetched
                }
                
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

            staffDetailsVC.existingStaff = self.allStaff
            
            staffDetailsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(staffDetailsVC, animated: true)
            
            // if a Students cell/object has been selected, segue to Student Details VC
        case .students:
            let studentDetailsVC = storyboard.instantiateViewController(withIdentifier: "StudentDetailsVC") as! StudentDetailsVC
            
                // if showing details for existing entity, pass object to destination VC, otherwise show empty form
            if entity != nil {
                studentDetailsVC.student = entity as? Student
            }
            
            studentDetailsVC.existingStudents = allStudents
            
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
        newEntityButton.setTitle("  Add", for: .normal)
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
