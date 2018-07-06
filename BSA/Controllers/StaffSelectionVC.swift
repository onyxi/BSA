//
//  StaffSelectionVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 28/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

protocol StaffSelectionDelegate {
    func setStaff(to selection: [Staff])
}

class StaffSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var staffSelectionDelegate: StaffSelectionDelegate!
    
    var allStaff = [Staff]()
    var selectedStaff = [Staff]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Please Select..."
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
        allStaff = Data.getStaff()
        tableView.reloadData()
        
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        if selectedStaff.isEmpty {
            // alert - please select staff
            let alert = UIAlertController(title: "No Selection", message: "Please select one or more staff members", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            staffSelectionDelegate.setStaff(to: selectedStaff)
            self.navigationController?.popViewController(animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allStaff.isEmpty {
            return 0
        } else {
            return allStaff.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaffTopPaddingCell", for: indexPath) as! TransparentCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == allStaff.count + 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaffOKButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
        } else {
        
            let staff = allStaff[indexPath.row - 1]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaffCell", for: indexPath) as! StaffCell
            cell.staffNameLabel.text = "\(staff.firstName!) \(staff.lastName!)"
            
            if selectedStaff.contains(staff) {
                cell.checkboxImage.image = UIImage(named: "boxChecked")
                cell.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
            }
            return cell
        }        
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 20
        } else if indexPath.row == allStaff.count + 1 {
            return 125
        } else {
            return 80
        }
    }

}
