//
//  RAGAssessmentsVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 16/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class RAGAssessmentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var dayDateLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dateOffset: Int?
    var selectedPeriod: Int?
    
    var students = [Student]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.backgroundColor = Constants.RAG_SCREEN_COLOR.cgColor
        self.navigationItem.title = "RAG Assessments"
        
        setupSubtitleBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()

        students = Data.getClassStudents()
        tableView.reloadData()
        
    }
    
    @IBAction func saveChangesButtonPressed(_ sender: Any) {
        // save assessments first ...
        self.navigationController?.popViewController(animated: true)
    }

    func setupSubtitleBar() {
        guard dateOffset != nil else { return }
        guard selectedPeriod != nil else { return }
        
        dayNameLabel.text = Data.getDayString(for: dateOffset!)
        dayDateLabel.text = Data.getDateString(for: dateOffset!)
        
        periodLabel.text = "Period \(selectedPeriod!)"
        periodLabel.backgroundColor = Constants.BLUE
        periodLabel.textColor = .white
        periodLabel.layer.cornerRadius = 8
        periodLabel.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if students.isEmpty {
            return 0
        } else {
            return students.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RAGAssessmentsTopPaddingCell", for: indexPath) as! TransparentCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == students.count + 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RAGAssessmentsSaveChangesButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
        
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RAGAssessmentCell", for: indexPath) as! RAGAssessmentCell
            let student = students[indexPath.row - 1]
            cell.studentNameLabel.text = "\(student.firstName!) \(student.lastName!)"
            cell.updateButtonLayout()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 20
        } else if indexPath.row == students.count + 1 {
            return 125
        } else {
            return 80
        }
        return 90
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            let orient = UIApplication.shared.statusBarOrientation
            
            switch orient {
                
            case .portrait:
                
                print("Portrait")
                
            case .landscapeLeft,.landscapeRight :
                
                print("Landscape")
                
            default:
                
                print("Anything But Portrait")
            }
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            //refresh view once rotation is completed not in will transition as it returns incorrect frame size.Refresh here
            
            self.tableView.reloadData()
            
        })
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        if students != nil {
//            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
//            let height = (cell?.contentView.bounds.height)! * CGFloat(students.count)
//            self.tableViewHeight.constant = height
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    */

}
