//
//  PurposeSelectionVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 28/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows an array of selected Purpose objects to be sent to the delegate
protocol PurposeSelectionDelegate {
    func setPurpose(to selection: [String])
}

class PurposeSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // UI handles:
    @IBOutlet weak var tableView: UITableView!
    
    // Properties:
    var purposeSelectionDelegate: PurposeSelectionDelegate!
    var allPurposes = [String]()
    var selectedPurposes = [String]()

    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()

            // set color and title
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Please Select..."
        
            // set up table of Purposes
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
    
            // load purpose-type values from Constants and reload table
        getPurposes()
        tableView.reloadData()
    
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

    // Loads purpose-type values from Constants
    func getPurposes() {
        allPurposes.append(Constants.PURPOSES.socialAttention)
        allPurposes.append(Constants.PURPOSES.tangibles)
        allPurposes.append(Constants.PURPOSES.escape)
        allPurposes.append(Constants.PURPOSES.sensory)
        allPurposes.append(Constants.PURPOSES.health)
        allPurposes.append(Constants.PURPOSES.activityAvoidance)
        allPurposes.append(Constants.PURPOSES.unknown)
    }

    // Sets number of rows in the table of Purposes
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allPurposes.isEmpty {
            return 0
        } else {
          return allPurposes.count + 2
        }
    }
    
    // Configures cells in the table of Purposes
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // transparent cell used as padding at the top of the table
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PurposeTopPaddingCell", for: indexPath) as! TransparentCell
            cell.selectionStyle = .none
            return cell
            
            // transparent cell containing the 'OK' button as the last row in the table
        } else if indexPath.row == allPurposes.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PurposeOKButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
            // configure 'Purpose' cell for all other cells
        } else {
            let purpose = allPurposes[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "PurposeCell", for: indexPath) as! PurposeCell
            cell.purposeTypeLabel.text = purpose
            
                // update cell appearance according to whether the current cell corresponds to a Purpose currently contained in the array of selected Purposes
            if selectedPurposes.contains(purpose) {
                cell.checkboxImage.image = UIImage(named: "boxChecked")
                cell.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
            }
            return cell
        }
    }
    
    // Updates current Purpose selection when corresponding cell is pressed. If the cell corresponding to a Purpose that is already contained in the array of selected Purposes is pressed, that Purpose is added to the array. If the array already contains that Purpose, it is removed from the array of selected Purposes
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 && indexPath.row != allPurposes.count + 1 else { return }
        
        let cell = tableView.cellForRow(at: indexPath) as? PurposeCell
        let purpose = allPurposes[indexPath.row - 1]
        
        if selectedPurposes.contains(purpose) {
            if let index = selectedPurposes.index(of: purpose) {
                selectedPurposes.remove(at: index)
                cell?.checkboxImage.image = UIImage(named: "box")
            }
        } else {
            selectedPurposes.append(purpose)
        }
        tableView.reloadData()
    }
    
    
    // Sets the height for cells in table of Purposes
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 20
        } else if indexPath.row == allPurposes.count + 1 {
            return 125
        } else {
            return 80
        }
    }
    
    
    // Sets parent VC's 'Purposes' value to thic VC's array of selected Purposes, before segueing back to parent VC. If no Purposes are selected, an alert is shown to the user to prompt selection.
    @IBAction func okButtonPressed(_ sender: Any) {

            // if no Purpose selected present alert
        guard !selectedPurposes.isEmpty else {
            let alert = UIAlertController(title: "No Selection", message: "Please select one or more purposes", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
            
            // pass selected Purposes array to delegate and segue back
        purposeSelectionDelegate.setPurpose(to: selectedPurposes)
        self.navigationController?.popViewController(animated: true)
    }
    
}
