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
    
    @IBOutlet weak var activityIndicatorBackground: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var blurEffectView: UIView?
    
    // Properties:
    var dateOffset: Int!
    var selectedPeriod: String!
    var students: [Student]?
    var rAGSelections = [String]()
    var periodRAGAssessments: [RAGAssessment]?
    var dataService: DataService!
    
    var connectionTimer: Timer!
    
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
        
            // initialise DataService
        dataService = DataService()
        
            // add swipe-gesture recognisers to main view
        addGestureRecognisers()
    
            // add blur while data loads
        setupActivityIndicator()
        
        // add timer for connection time-out
        connectionTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(showConnectionTimeOutAlert), userInfo: nil, repeats: false)
        
        // get students' data from selection and reload table
        configureStudentAssessments()
        
    }
    
    @objc func showConnectionTimeOutAlert() {
        let alert = UIAlertController(title: "Network Error", message: "Please check your network connection", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//            self.connectionTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.showConnectionTimeOutAlert), userInfo: nil, repeats: false)
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
    
    
    
    
    // Assigns initial value of 'none' for RAG Assessment of each Student. If previously completed assessments have been passed in from parent, update student's RAG statuses accordingly
    func configureStudentAssessments() {
        
        // check to make sure students have been fetched
        guard students != nil else {
            print ("unable to fetch students")
            return
        }
        
        // hide activity indicator ow that data is loaded
        activityIndicator.stopAnimating()
        connectionTimer.invalidate()
        UIView.animate(withDuration: 0.2, animations: {
            self.blurEffectView!.alpha = 0.0
        }) { (nil) in
            self.activityIndicatorBackground.isHidden = true
            self.activityIndicator.isHidden = true
        }
        
        for student in students! {
            
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
    
    // Reloads table when view appears
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // Creates new RAG assessments in database from user's input
    @IBAction func saveChangesButtonPressed(_ sender: Any) {
        
        // check to make sure students have been fetched
        guard students != nil else {
            print ("unable to fetch students")
            return
        }

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
        
        let dispatchGroup = DispatchGroup()
        var uploadError = false
        
            // pack RAG Assessments for saving
        for i in 0...students!.count - 1 {
            dispatchGroup.enter()
            let rag = RAGAssessment(
                id: NSUUID().uuidString,
                date: Date().withOffset(dateOffset: dateOffset),
                period: selectedPeriod,
                studentNumber: students![i].studentNumber,
                assessment: rAGSelections[i])
            
            dataService.createRAGAssessment(rAGAssessment: rag) { (ragID, message) in
                if ragID != nil {
                    print ("Created RAG: \(message)")
                    
                    // alert user if problem with upload
                } else {
                    uploadError = true
                }
                dispatchGroup.leave()
            }
            
        }
        dispatchGroup.notify(queue: .main) {
            if uploadError {
                let alert = UIAlertController(title: "Error Saving RAG Assessment", message: "Please check your connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "RAG Assessments Saved", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
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
        var periodStr = "Period "
        switch selectedPeriod {
        case "p1":
            periodStr += "1"
        case "p2":
            periodStr += "2"
        case "p3":
            periodStr += "3"
        case "p4":
            periodStr += "4"
        case "p5":
            periodStr += "5"
        case "p6":
            periodStr += "6"
        case "p7":
            periodStr += "7"
        default: break
        }
        periodLabel.text = periodStr
        periodLabel.backgroundColor = Constants.BLUE
        periodLabel.textColor = .white
        periodLabel.layer.cornerRadius = 8
        periodLabel.layer.masksToBounds = true
    }
    
    
    // Sets number of rows in the table of RAG Assessment cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if students == nil || students!.isEmpty {
            return 0
        } else {
            return students!.count + 2
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
        } else if indexPath.row == students!.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RAGAssessmentsSaveChangesButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
        
            // configure 'RAG Assessment Cell' for all other cells
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RAGAssessmentCell", for: indexPath) as! RAGAssessmentCell
            cell.tag = indexPath.row
            
            let student = students![indexPath.row - 1]
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
        } else if students != nil && indexPath.row == students!.count + 1 {
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
