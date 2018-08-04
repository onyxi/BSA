//
//  AdminReportsVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 11/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class AdminReportsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, EntityGroupSwitchDelegate, WholeSchoolDeselectionDelegate, ViewReportsForSelectionDelegate, SchoolClassFetchingDelegate, StudentFetchingDelegate {
    
    
    // UI handles:
    @IBOutlet weak var entityTableContainerView: UIView!
     @IBOutlet weak var tableView: UITableView!
    
    // Properties:
    var classesWithStudents: [(SchoolClass, [Student])]?
    var allSchoolClasses: [SchoolClass]?
    var allStudents: [Student]?
    var entityTableContainerVC: AdminReportsEntityTableContainerVC!
    
    var dataService: DataService?
//    var analysis: AdminReportAnalysis?
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // set VC color and title, and add logout button
        view.layer.backgroundColor = Constants.ADMIN_REPORTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Reports Selection"
        addLogoutButton()
        
            // set up table for Whole School selection cell
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        
            // get all Class objects (and the Students associated with that class) from storage, and reload table
        dataService = DataService()
        dataService?.schoolClassFetchingDelegate = self
        dataService?.studentFetchingDelegate = self
        
        dataService?.getAllSchoolClasses()
        
//        analysis = Analysis()
//        analysis?.adminReportAnalysisDelegate = self
//        analysis?.analyseAdminReportData(for: )
        
//        classesWithStudents = Data.getAllClassesWithStudents()
//        tableView.reloadData()
        
            // send the retrieved Class (and associated Students) objects to the container view for unpacking and representation in its table of students
//        entityTableContainerVC.unpackClassesWithStudents(classesWithStudents: classesWithStudents)
    }
    
    
    
    func finishedFetching(schoolClasses: [SchoolClass]) {
        dataService?.getStudents(for: schoolClasses)
    }
    
    func finishedFetching(students: [Student]) {
        // no implementation needed in this class
    }
    
    func finishedFetching(classesWithStudents: [(schoolClass: SchoolClass, students: [Student])]) {
        self.classesWithStudents = classesWithStudents
        entityTableContainerVC.unpackClassesWithStudents(classesWithStudents: classesWithStudents)
        tableView.reloadData()
    }
    

    

    
    // Sets number of rows in the small header-table showing just the whole-school cell (or nothing if no Class/Student data was returned from storage)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if classesWithStudents == nil {
            return 0
        } else {
            return 2
        }
    }
    
    // Configures cells in the small header-table showing just the whole-school cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // transparent cell used as padding at the top of the table
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminReportsTopPaddingCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
            // configure cell with 'whole school' selection switch
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminReportsWholeSchoolCell", for: indexPath) as! AdminReportsEntityGroupCell
            cell.titleLabel.text = "Whole School"
            cell.selectionStyle = .none
            cell.entityGroupSwitchDelegate = self
            return cell
        }
    }
    
    
    // Sets the height for cells in the small header-table showing just the whole-school cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 10
        } else {
            return 70
        }
    }
    
    
    // Assigns the container view itself to a local variable (to allow local access to it later), and assigns this VC as required delegate to the container view - for responding to the user's selection inputs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AdminReportsEntityTableContainerVC,
            segue.identifier == "showEntityTableContainerSegue" {
            self.entityTableContainerVC = vc
            vc.wholeSchoolDeselectionDelegate = self
            vc.viewReportsForSelectionDelegate = self
        }
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
            // segue to login screen
            // remove record of logged in account and segue to login screen
            //            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_NUMBER_KEY)
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_ID)
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_NAME)
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_SECURITY_LEVEL)
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_CLASS_ID)
            self.performSegue(withIdentifier: "unwindAdminReportsVCToLoginVCSegue", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Sets the UISwitch in the 'Whle School' selection cell to 'off' - in response to the user deselecting any student in the container's table view (whole-school selection is only true if all students are selected)
    func deselectWholeSchool() {
        for cell in tableView.visibleCells {
            if let wholeSchoolCell = cell as? AdminReportsEntityGroupCell {
                wholeSchoolCell.selectionSwitch.setOn(false, animated: true)
            }
        }
    }
    
    // Updates the container view when the user deselects or deselects the 'whole school' cell UISwitch. The container view can then set selection true or false as required for student cells.
    func selectionSwitchChangedValueFor(cellWithTag tag: Int, to value: Bool) {
        entityTableContainerVC.selectionSwitchChangedForWholeSchool(to: value)
    }
    
    
    // Triggers segue to Reports screen, passing in the Students selected from the container's table view. The array of students can then be used when to retrieve a filtered data set from storage.
    func viewReportsFor(selection: [Student]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let adminReportsDataVC = storyboard.instantiateViewController(withIdentifier: "AdminReportsDataVC") as! AdminReportsDataVC
        adminReportsDataVC.hidesBottomBarWhenPushed = true
        adminReportsDataVC.studentSelection = selection
        self.navigationController?.pushViewController(adminReportsDataVC, animated: true)
    }
    
    

}
