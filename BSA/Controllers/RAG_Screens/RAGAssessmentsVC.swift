//
//  RAGAssessmentsVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 16/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class RAGAssessmentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, RAGSelectionDelegate {
    
    
    // UI handles:
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var dayDateLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // Properties:
    var dateOffset: Int!
    var selectedPeriod: String!
    var students: [Student]!
    var rAGSelections = [String]()
    var periodRAGAssessments: [RAGAssessment]?
    
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()

            // set VC color, title and subtitle bar
        view.layer.backgroundColor = Constants.RAG_SCREEN_COLOR.cgColor
        self.navigationItem.title = "RAG Assessments"
        setupSubtitleBar()
        
            // set up table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
            // get students' data from storage and reload table
        configureStudentAssessments()
        
    }
    
    func configureStudentAssessments() {
//        students = Data.getAllStudents()
        for student in students {
            
            var assessment: String = "none"
            
            if periodRAGAssessments != nil {
                for rag in periodRAGAssessments! {
                    if rag.studentNumber == student.studentNumber {
                        assessment = rag.assessment
                    }
                }
            }
            rAGSelections.append(assessment)
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    @IBAction func saveChangesButtonPressed(_ sender: Any) {

        // check to make sure all students have been assessed
        guard !rAGSelections.contains("none") else {
            
                // if not, show alert to inform all students must be assessed
            let alert = UIAlertController(title: "Assessment Incomplete", message: "Please assess all students before saving changes", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
            // pack RAG Assessments for saving
        var completedRAGAssessments = [RAGAssessment]()
        for i in 0...students.count - 1 {
            let rag = RAGAssessment(
                id: NSUUID().uuidString,
                date: Date().withOffset(dateOffset: dateOffset),
                period: selectedPeriod,
                studentNumber: students[i].studentNumber,
                assessment: rAGSelections[i])
            completedRAGAssessments.append(rag)
        }
        
       

        // save rag assessments here!!!
        
//        Data.saveRAGAssessments(ragAssessments: completedRAGAssessments)
        
        self.navigationController?.popViewController(animated: true)
    }

    
    // Configures subtitle bar according to selected date and period
    func setupSubtitleBar() {
        
            // check that selected day and period have been passed through from parent VC
        guard dateOffset != nil else { return }
        guard selectedPeriod != nil else { return }
        
            // set day / date labels
        dayNameLabel.text = DataService.getDayString(for: dateOffset!)
        dayDateLabel.text = DataService.getDateString(for: dateOffset!)
        
            // set period label
        periodLabel.text = "Period \(selectedPeriod!)"
        periodLabel.backgroundColor = Constants.BLUE
        periodLabel.textColor = .white
        periodLabel.layer.cornerRadius = 8
        periodLabel.layer.masksToBounds = true
    }
    
    
    // Sets number of rows in the table of RAG Assessment cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if students.isEmpty {
            return 0
        } else {
            return students.count + 2
        }
    }
    
    
    // Configures the cells in the table of RAG Assessment cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // transparent cell used as padding at the top of the table
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RAGAssessmentsTopPaddingCell", for: indexPath) as! TransparentCell
            cell.selectionStyle = .none
            return cell
            
            // transparent cell containing the 'Save Changes' button as the last row in the table
        } else if indexPath.row == students.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RAGAssessmentsSaveChangesButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
        
            // configure 'RAG Assessment Cell' for all other cells
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RAGAssessmentCell", for: indexPath) as! RAGAssessmentCell
            cell.tag = indexPath.row
            
            let student = students[indexPath.row - 1]
            cell.studentNameLabel.text = "\(student.firstName!) \(student.lastName!)"
            
            let selection = rAGSelections[indexPath.row - 1]
            cell.selectionIndicatorPosition = selection
            
            cell.rAGSelectionDelegate = self
            cell.refreshSelectionIndicator()
            return cell
        }
    }
    
    
    // Sets the height for cells in table
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 20
        } else if indexPath.row == students.count + 1 {
            return 125
        } else {
            return 80
        }
    }
    
    
    // Sets the RAG assessment selection for a given student
    func didSelectRAG(selection: String, forCellWith tag: Int) {
        rAGSelections[tag - 1] = selection
    }
    
    
    
}
