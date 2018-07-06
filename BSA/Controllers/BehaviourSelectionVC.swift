//
//  BehaviourSelectionVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 27/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

protocol BehaviourSelectionDelegate {
    func setBehaviours(to selection: [Behaviour])
}

class BehaviourSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var behaviourSelectionDelegate: BehaviourSelectionDelegate?
    
    var allBehaviours = [Behaviour]()
    var selectedBehaviours = [Behaviour]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Please Select..."
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
        allBehaviours = Data.getBehaviours()
        tableView.reloadData()
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        if selectedBehaviours.isEmpty {
           // alert - please select a behaviour
            let alert = UIAlertController(title: "No Selection", message: "Please select one or more behaviours", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            behaviourSelectionDelegate?.setBehaviours(to: selectedBehaviours)
            self.navigationController?.popViewController(animated: true)
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allBehaviours.isEmpty {
            return 0
        } else {
            return allBehaviours.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BehaviourTopPaddingCell", for: indexPath) as! TransparentCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == allBehaviours.count + 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BehaviourOKButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
        } else {
            
            let behaviour = allBehaviours[indexPath.row - 1]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BehaviourCell", for: indexPath) as! BehaviourCell
            cell.behaviourTypeLabel.text = "\(behaviour.type!)"
    
            if selectedBehaviours.contains(behaviour) {
                cell.checkboxImage.image = UIImage(named: "boxChecked")
                cell.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
            }
            return cell
        }
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 20
        } else if indexPath.row == allBehaviours.count + 1 {
            return 125
        } else {
            return 80
        }
    }
    
}
