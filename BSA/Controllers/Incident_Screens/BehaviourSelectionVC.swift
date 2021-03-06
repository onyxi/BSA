//
//  BehaviourSelectionVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 27/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows an array of selected Behaviours objects to be sent to the delegate
protocol BehaviourSelectionDelegate {
    func setBehaviours(to selection: [String])
}

class BehaviourSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // UI handles:
    @IBOutlet weak var tableView: UITableView!
    
    // Properties:
    var behaviourSelectionDelegate: BehaviourSelectionDelegate?
    var allBehaviours = [String]()
    var selectedBehaviours = [String]()

    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()

            // set VC color and title
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Please Select..."
        
            // set up table of Behaviours
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
            // load behaviour-type values from Constants and reload table
        getBehaviours()
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
    
    // Loads behaviour-type values from Constants
    func getBehaviours() {
        allBehaviours.append(Constants.BEHAVIOURS.kicking)
        allBehaviours.append(Constants.BEHAVIOURS.headbutt)
        allBehaviours.append(Constants.BEHAVIOURS.hitting)
        allBehaviours.append(Constants.BEHAVIOURS.biting)
        allBehaviours.append(Constants.BEHAVIOURS.slapping)
        allBehaviours.append(Constants.BEHAVIOURS.scratching)
        allBehaviours.append(Constants.BEHAVIOURS.clothesGrabbing)
        allBehaviours.append(Constants.BEHAVIOURS.hairPulling)
    }

    // Sets number of rows in the table of Behaviours
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allBehaviours.isEmpty {
            return 0
        } else {
            return allBehaviours.count + 2
        }
    }
    
    // Configures cells in the table of Students
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // transparent cell used as padding at the top of the table
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BehaviourTopPaddingCell", for: indexPath) as! TransparentCell
            cell.selectionStyle = .none
            return cell
            
            // transparent cell containing the 'OK' button as the last row in the table
        } else if indexPath.row == allBehaviours.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BehaviourOKButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
            // configure 'Behaviour' cell for all other cells
        } else {
            let behaviour = allBehaviours[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "BehaviourCell", for: indexPath) as! BehaviourCell
            
            var behaviourString = ""
            switch behaviour {
            case Constants.BEHAVIOURS.kicking:
                behaviourString = "Kicking"
            case Constants.BEHAVIOURS.headbutt:
                behaviourString = "Headbutt"
            case Constants.BEHAVIOURS.hitting:
                behaviourString = "Hitting"
            case Constants.BEHAVIOURS.biting:
                behaviourString = "Biting"
            case Constants.BEHAVIOURS.slapping:
                behaviourString = "Slapping"
            case Constants.BEHAVIOURS.scratching:
                behaviourString = "Scratching"
            case Constants.BEHAVIOURS.clothesGrabbing:
                behaviourString = "Clothes Grabbing"
            case Constants.BEHAVIOURS.hairPulling:
                behaviourString = "Hair Pulling"
            default: break
            }
        
            cell.behaviourTypeLabel.text = behaviourString
    
                // update cell appearance according to whether the current cell corresponds to a Behaviour currently contained in the array of selected Behaviours
            if selectedBehaviours.contains(behaviour) {
                cell.checkboxImage.image = UIImage(named: "boxChecked")
                cell.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
            }
            return cell
        }
    }
    
    
    // Updates current Behaviours selection when corresponding cell is pressed. If the cell corresponding to a Behaviour not already contained in the array of selected Behaviours is pressed, that behaviour is added to the array. If the array already contains that behaviour, it is removed from the array of selected Behaviours
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 && indexPath.row != allBehaviours.count + 1 else { return }
        
        let cell = tableView.cellForRow(at: indexPath) as? BehaviourCell
        let behaviour = allBehaviours[indexPath.row - 1]
        
        if selectedBehaviours.contains(behaviour) {
            if let index = selectedBehaviours.index(of: behaviour) {
                selectedBehaviours.remove(at: index)
                cell?.checkboxImage.image = UIImage(named: "box")
            }
        } else {
            selectedBehaviours.append(behaviour)
        }
        tableView.reloadData()
    }
    
    // Sets the height for cells in table of behaviours
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 20
        } else if indexPath.row == allBehaviours.count + 1 {
            return 125
        } else {
            return 80
        }
    }
    
    
    // Sets parent VC's 'Behaviours' value to thic VC's array of selected Behaviours, before segueing back to parent VC. If no Behaviours are selected, an alert is shown to the user to prompt selection.
    @IBAction func okButtonPressed(_ sender: Any) {
        
            // if no Behaviour selected present alert
        guard !selectedBehaviours.isEmpty else {
            let alert = UIAlertController(title: "No Selection", message: "Please select one or more behaviours", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
    
            // pass selected Behaviours array to delegate and segue back
        behaviourSelectionDelegate?.setBehaviours(to: selectedBehaviours)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
