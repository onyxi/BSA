//
//  StudentSelectionVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 26/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

protocol StudentSelectionDelegate {
    func setStudent(to selection: Student)
}

class StudentSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var studentSelectionDelegate: StudentSelectionDelegate?
    
    var allStudents = [Student]()
    var selectedStudent: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Please Select..."
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
        allStudents = Data.getClassStudents()
        tableView.reloadData()
        
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        if selectedStudent == nil {
            // alert - please select student
            let alert = UIAlertController(title: "No Selection", message: "Please select a student", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            studentSelectionDelegate?.setStudent(to: selectedStudent!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allStudents.isEmpty {
            return 0
        } else {
            return allStudents.count + 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTopPaddingCell", for: indexPath) as! TransparentCell
            cell.selectionStyle = .none
            return cell
        
        } else if indexPath.row == allStudents.count + 1 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentOKButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
        } else {
            
            let student = allStudents[indexPath.row - 1]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentCell
            cell.studentNameLabel.text = "\(student.firstName!) \(student.lastName!)"
            
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 0
        } else if indexPath.row == allStudents.count + 1 {
            return 125
        } else {
            return 80
        }
    }


}
