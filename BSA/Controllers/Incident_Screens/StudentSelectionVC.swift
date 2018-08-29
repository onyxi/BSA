//
//  StudentSelectionVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 26/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows a selected Student object to be sent to the delegate
protocol StudentSelectionDelegate {
    func setStudent(to selection: Student)
}

class StudentSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SchoolClassFetchingDelegate, StudentFetchingDelegate {
    
    
    // UI handles:
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicatorBackground: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var blurEffectView: UIView?
    
    // Properties:
    var studentSelectionDelegate: StudentSelectionDelegate?
    var allStudents = [Student]()
    var selectedStudent: Student?
    var selectedStudentNumber: Int?
    var schoolClass: SchoolClass?
    
    var dataService: DataService!
    
    var connectionTimer: Timer!
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()

            // set VC color and title
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Please Select..."
        
            // set up table of Students
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
            // initialise DataService
        dataService = DataService()
        dataService.schoolClassFetchingDelegate = self
        dataService.studentFetchingDelegate = self
        
            // Check logged-in user - if 'Admin', get all students, otherwise request associated School Class object
        if UserDefaults.standard.string(forKey: Constants.LOGGED_IN_ACCOUNT_NAME) == "Admin" {
            dataService.getAllStudents()
        } else {
            dataService.getSchoolClass(withId: UserDefaults.standard.string(forKey: Constants.LOGGED_IN_ACCOUNT_CLASS_ID)!)
        }
        
            // add swipe-gesture recognisers to main view
        addGestureRecognisers()
    
            // add blur while data loads
        setupActivityIndicator()
    
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
    
    // Requests Students associated with fetched School Class object
    func finishedFetching(schoolClasses: [SchoolClass]) {
        dataService.getStudents(for: schoolClasses[0])
    }
    
    // Assigns fetched Student objects to class-level scope and searches fetched students to find the selected Student passed from parent VC (if any), before reloading table - to be populated with fetched data
    func finishedFetching(students: [Student]) {
        
        // hide activity indicator ow that data has loaded
        activityIndicator.stopAnimating()
        connectionTimer.invalidate()
        UIView.animate(withDuration: 0.2, animations: {
            self.blurEffectView!.alpha = 0.0
        }) { (nil) in
            self.activityIndicatorBackground.isHidden = true
            self.activityIndicator.isHidden = true
        }
        
        allStudents = students
        
        if selectedStudentNumber != nil {
            for student in allStudents {
                if student.studentNumber == selectedStudentNumber {
                    selectedStudent = student
                }
            }
        }
        
        tableView.reloadData()
    }
    
    
    // Sets number of rows in the table of Students
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allStudents.isEmpty {
            return 0
        } else {
            return allStudents.count + 2
        }
    }

    
    // Configures cells in the table of Students
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // transparent cell used as padding at the top of the table
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTopPaddingCell", for: indexPath) as! TransparentCell
            cell.selectionStyle = .none
            return cell
        
            // transparent cell containing the 'OK' button as the last row in the table
        } else if indexPath.row == allStudents.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentOKButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
            // configure 'Student' cell for all other cells
        } else {
            let student = allStudents[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentCell
            cell.studentNameLabel.text = "\(student.firstName!) \(student.lastName!)"
            
                // update cell appearance according to whether the current cell corresponds to a potentially selected Student
            if selectedStudent == nil {
                cell.backgroundColor = UIColor.white
                cell.checkImage.image = nil
            } else {
                if selectedStudent! == student {
                    cell.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
                    cell.checkImage.image = UIImage(named: "check")
                } else {
                    cell.backgroundColor = UIColor.white
                    cell.checkImage.image = nil
                }
            }
            return cell
        }
    }
    
    
    // Updates current Student selection when corresponding cell is pressed. If the cell corresponding to the already selected student is pressed, it is deselected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 && indexPath.row != allStudents.count + 1 else { return }
        
        let student = allStudents[indexPath.row - 1]
        
        if selectedStudent == nil {
            selectedStudent = student
        } else {
            if selectedStudent == student {
                selectedStudent = nil
            } else {
               selectedStudent = student
            }
        }
        tableView.reloadData()
    }

    
    // Sets the height for cells in table of Students
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 20
        } else if indexPath.row == allStudents.count + 1 {
            return 125
        } else {
            return 80
        }
    }
    
    
    // Sets parent VC's 'Student' value to thic VC's selected value, before segueing back to parent VC. If no student is selected, an alert is shown to the user to prompt selection.
    @IBAction func okButtonPressed(_ sender: Any) {
        
            // if no student selected present alert
        guard selectedStudent != nil else {
            let alert = UIAlertController(title: "No Selection", message: "Please select a student", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
            // pass selected Student to delegate and segue back
        studentSelectionDelegate?.setStudent(to: selectedStudent!)
        self.navigationController?.popViewController(animated: true)
    }

    func finishedFetching(classesWithStudents: [(schoolClass: SchoolClass, students: [Student])]) {
        // needed to conform to protocol - no implementation needed in this class
    }

}
