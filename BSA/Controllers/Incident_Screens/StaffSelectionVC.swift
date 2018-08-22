//
//  StaffSelectionVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 28/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows an array of selected Staff objects to be sent to the parent VC
protocol StaffSelectionDelegate {
    func setStaff(to selection: [Staff])
}

class StaffSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, StaffFetchingDelegate {

    // UI handles:
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicatorBackground: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var blurEffectView: UIView?
    
    // Properties:
    var staffSelectionDelegate: StaffSelectionDelegate!
    var allStaff = [Staff]()
    var selectedStaff = [Staff]()
    var selectedStaffNumbers: [Int]?
    var dataService: DataService?
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()

            // set VC color and title
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Please Select..."
        
            // set up table of Staff members
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
            // initialise DataService and request Staff objects from storage
        dataService = DataService()
        dataService?.staffFetchingDelegate = self
        dataService?.getAllStaffMembers()
        
            // add swipe-gesture recognisers to main view
        addGestureRecognisers()

            // add blur while data loads
        setupActivityIndicator()
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
    
    // Assigns fetched Staff objects to class-level scope and searches fetched Staff members to find the selected Staff passed from parent VC (if any), before reloading table - to be populated with fetched data
    func finishedFetching(staffMembers: [Staff]) {
        
            // hide activity indicator ow that data has loaded
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2, animations: {
            self.blurEffectView!.alpha = 0.0
        }) { (nil) in
            self.activityIndicatorBackground.isHidden = true
            self.activityIndicator.isHidden = true
        }
        
        allStaff = staffMembers
        if selectedStaffNumbers != nil {
            var selectedStaff = [Staff]()
            for staff in allStaff {
                if selectedStaffNumbers!.contains(staff.staffNumber) {
                    selectedStaff.append(staff)
                }
            }
            self.selectedStaff = selectedStaff
        }
        
        tableView.reloadData()
    }
    

    // Sets number of rows in the table of Staff members
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allStaff.isEmpty {
            return 0
        } else {
            return allStaff.count + 2
        }
    }
    
    // Configures cells in the table of Staff
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // transparent cell used as padding at the top of the table
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaffTopPaddingCell", for: indexPath) as! TransparentCell
            cell.selectionStyle = .none
            return cell
            
            // transparent cell containing the 'OK' button as the last row in the table
        } else if indexPath.row == allStaff.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaffOKButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
            // configure 'Staff' cell for all other cells
        } else {
            let staff = allStaff[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaffCell", for: indexPath) as! StaffCell
            cell.staffNameLabel.text = "\(staff.firstName!) \(staff.lastName!)"
            
                // update cell appearance according to whether the current cell corresponds to a Staff member currently contained in the array of selected Staff members
            if selectedStaff.contains(staff) {
                cell.checkboxImage.image = UIImage(named: "boxChecked")
                cell.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
            }
            return cell
        }        
    }
    
    
    // Updates current Staff selection when corresponding cell is pressed. If the cell corresponding to a Staff member not already contained in the array of selected Staff members is pressed, that Staff member is added to the array. If the array already contains that Staff member, it is removed from the array of selected Staff members
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 && indexPath.row != allStaff.count + 1 else { return }
        
        let cell = tableView.cellForRow(at: indexPath) as? StaffCell
        let staff = allStaff[indexPath.row - 1]
        
        if selectedStaff.contains(staff){
            if let index = selectedStaff.index(of: staff) {
                selectedStaff.remove(at: index)
                cell?.checkboxImage.image = UIImage(named: "box")
            }
        } else {
            selectedStaff.append(staff)
        }
        tableView.reloadData()
    }
    
    
    // Sets the height for cells in table of Staff members
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 20
        } else if indexPath.row == allStaff.count + 1 {
            return 125
        } else {
            return 80
        }
    }
    
    
    // Sets delegate VC's 'Staff' value to thic VC's array of selected Staff members, before segueing back to parent VC. If no Staff members are selected, an alert is shown to the user to prompt selection.
    @IBAction func okButtonPressed(_ sender: Any) {
        
            // if no Staff selected present alert
        guard !selectedStaff.isEmpty else {
            let alert = UIAlertController(title: "No Selection", message: "Please select one or more staff members", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
            
            // pass selected Staff array to delegate and segue back
        staffSelectionDelegate.setStaff(to: selectedStaff)
        self.navigationController?.popViewController(animated: true)
    }

}
