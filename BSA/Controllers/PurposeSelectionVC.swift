//
//  PurposeSelectionVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 28/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

protocol PurposeSelectionDelegate {
    func setPurpose(to selection: [Purpose])
}

class PurposeSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var purposeSelectionDelegate: PurposeSelectionDelegate!
    
    var allPurposes = [Purpose]()
    var selectedPurposes = [Purpose]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Please Select..."
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
        allPurposes = Data.getPurposes()
        tableView.reloadData()
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        if selectedPurposes.isEmpty {
            // alert - please select purpose
            let alert = UIAlertController(title: "No Selection", message: "Please select one or more purposes", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            purposeSelectionDelegate.setPurpose(to: selectedPurposes)
            self.navigationController?.popViewController(animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allPurposes.isEmpty {
            return 0
        } else {
          return allPurposes.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PurposeTopPaddingCell", for: indexPath) as! TransparentCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == allPurposes.count + 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PurposeOKButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
        } else {
            
            let purpose = allPurposes[indexPath.row - 1]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PurposeCell", for: indexPath) as! PurposeCell
            cell.purposeTypeLabel.text = "\(purpose.type!)"
            
            if selectedPurposes.contains(purpose) {
                cell.checkboxImage.image = UIImage(named: "boxChecked")
                cell.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
            }
            return cell
        }
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 20
        } else if indexPath.row == allPurposes.count + 1 {
            return 105
        } else {
            return 80
        }
    }
    
    
}
