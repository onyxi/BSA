//
//  AdminReportsDataVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 18/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit
import MessageUI

class AdminReportsDataVC: UIViewController, AdminReportAnalysisDelegate, MFMailComposeViewControllerDelegate {
    
    
    // UI handles:
    @IBOutlet weak var subtitleBarLabelMain: SubtitleLabel!
    @IBOutlet weak var subtitleBarLabelLeft: SubtitleLabel!
    @IBOutlet weak var subtitleBarArrowLeft: SubtitleBarArrowLeft!
    @IBOutlet weak var subtitleBarLabelRight: SubtitleLabel!
    @IBOutlet weak var subtitleBarArrowRight: SubtitleBarArrowRight!
    @IBOutlet weak var subtitleBarButtonLeft: UIButton!
    @IBOutlet weak var subtitleBarButtonRight: UIButton!
    @IBOutlet weak var dayViewReportXAlign: NSLayoutConstraint!
    @IBOutlet weak var weekViewReportXAlign: NSLayoutConstraint!
    @IBOutlet weak var incidentCharacteristicsReportXAlign: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicatorBackground: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var blurEffectView: UIView?
    
    // Properties:
    var studentSelection: [Student]!
    var currentShowingReportCategory: ReportCategory = .RAGsAndIncidentsDayView
    var dayViewReportAnimation: AnimationEngine!
    var weekViewReportAnimation: AnimationEngine!
    var incidentCharacteristicsReportAnimation: AnimationEngine!
    var dayViewReportContainerVC: RAGsAndIncidentsDayViewReportContainerVC!
    var weekViewReportContainerVC: RAGsAndIncidentsWeekViewReportContainerVC!
    var incidentCharacteristicsReportContainerVC: IncidentCharacteristicsReportContainerVC!
    
    var dayViewChartData: [[Double]]?
    var weekViewChartData: [[Double]]?
    var incidentCharacteristicsChartData: (totalIncidents: Int, averageIntensity: Float, behaviourPercentages: [Double], purposePercentages: [Double])?
    
    var dataService: DataService?
    var analysis: AdminReportAnalysis?
    
    var data: AdminReportDataSet?
    
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()

            // set VC color and title, and add logout button
        view.layer.backgroundColor = Constants.ADMIN_REPORTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Reports"
        
            // configure report views
        setupSubtitleLabels()
        setupTableViews()
        
            // initialise DataService and AdminReportAnalysis classes, and request data analysis for selected Students
        dataService = DataService()
        analysis = AdminReportAnalysis()
        analysis?.adminReportAnalysisDelegate = self
        analysis?.analyseAdminReportData(for: studentSelection)
    
            // add swipe-gesture recognisers to main view
        addGestureRecognisers()
        
            // add blur while data loads
        setupActivityIndicator()
        
            // add custom back-button to navigation controller
        addBackButton()
        addEmailButton()
    }
    
    
    // Adds a custom configured 'Back' button to the navigation bar
    func addBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setTitle(" Back to Selection", for: .normal)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    //  Triggers segue back to selection screen
    @objc func backButtonPressed() {
        switch currentShowingReportCategory {
        case .RAGsAndIncidentsDayView:
            break
        case .RAGsAndIncidentsWeekView:
            dayViewReportContainerVC.hide()
        case .incidentCharacteristics:
            dayViewReportContainerVC.hide()
            weekViewReportContainerVC.hide()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // Adds a custom configured 'Email' button to the navigation bar
    func addEmailButton() {
        let emailButton = UIButton(type: .system)
        emailButton.setTitle(" Email .csv", for: .normal)
        emailButton.setImage(UIImage(named: "emailIcon"), for: .normal)
        emailButton.sizeToFit()
        emailButton.addTarget(self, action: #selector(self.emailButtonPressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: emailButton)
    }
    

    // Presents email view with attached .csv files (containing RAG Assessment and Incident data for the currently displayed report/student-selection) for user to email to external address.
    @objc func emailButtonPressed() {

            // present email window
        let emailViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(emailViewController, animated: true, completion: nil)
        }
        
    }
    
    
    // Creates .csv file containing all RAG Assessment data for current report / student selection
    func createRAGsCSVData() -> Data {
            // get all RAG Assessments
        let rAGAssessments = analysis?.rAGAssessments
        
            // setup String for .csv file
        var ragsString = NSMutableString()
        ragsString.append("Date,Period,Student,Status\n")
        
            // append rag assessments to String as new line per assessment
        for rag in rAGAssessments! {
            let newLine = "\(DataService.getShortDateString(for: rag.date)),\(rag.period!),\(rag.studentNumber!),\(rag.assessment!)\n"
            ragsString.append(newLine)
        }
        
            // compile and return .csv file
        let data = ragsString.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!
        
        return data
    }
    
    
    // Creates .csv file containing all Incident data for current report / student selection
    func createIncidentsCSVData() -> Data {
            // get all RAG Assessments
        let incidents = analysis?.incidents
        
            // setup String for .csv file
        let incidentsString = NSMutableString()
        incidentsString.append("Date,Time,Duration,Student,Behaviours (space-separated),Intensity,Staff (space-separated),Accident Form Completed,Restraint,Alarm Pressed,Purposes (space-separated),Notes\n")
        
            // append incidents to String as new line per assessment
        for incident in incidents! {
            
            let date = DataService.getShortDateString(for: incident.dateTime)
            let time = DataService.getTimeString(for: incident.dateTime)
            let duration = incident.duration!
            let student = incident.student!
            var behaviours = ""
            for behaviour in incident.behaviours {
                behaviours.append("\(behaviour) ")
            }
            let intensity = incident.intensity!
            var staff = ""
            for staffMember in incident.staff {
                staff.append("\(staffMember) ")
            }
            let accidentFormCompleted = incident.accidentFormCompleted!
            let restraint = incident.restraint!
            let alarmPressed = incident.alarmPressed!
            var purposes = ""
            for purpose in incident.purposes {
                purposes.append("\(purpose) ")
            }
            let notes = incident.notes!
            
            let newLine = "\(date),\(time),\(duration),\(student),\(behaviours),\(intensity),\(staff),\(accidentFormCompleted),\(restraint),\(alarmPressed),\(purposes),\(notes)\n"
            incidentsString.append(newLine)
        }

            // compile and return .csv file
        let data = incidentsString.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!
        
        return data
        
    }
    
    // Returns a configured email-window with attached .csv files for RAG Assessments and Incidents data
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
            // create email window
        let emailController = MFMailComposeViewController()
        emailController.mailComposeDelegate = self
        emailController.setSubject("Behaviours Support App - Data Export")
        emailController.setMessageBody("", isHTML: false)
        
            // create and attach the RAG Assessments .csv file to the email
        let ragsCSV = createRAGsCSVData()
        emailController.addAttachmentData(ragsCSV, mimeType: "text/csv", fileName: "RAGsData.csv")
        
            // create and attach the Incidents .csv file to the email
        let incidentsCSV = createIncidentsCSVData()
        emailController.addAttachmentData(incidentsCSV, mimeType: "text/csv", fileName: "IncidentsData.csv")
        
            // return configured email window
        return emailController
    }
    
    // Handles outcome of email window activity. If email sent successfully - presents alert to inform user of success. If unsuccessful, present alert to inform user of failure - check connection and try again.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            break
        case .saved:
            break
        case .sent:
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                let alert = UIAlertController(title: "Email Sent", message: "RAG Assessmnt and Incident data for current report selection has been sent in .csv format. Please check your email inbox", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            break
        case .failed:
            let alert = UIAlertController(title: "Email Failed", message: "Failed to send email with .csv files - please check your connection and try again", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            break
        }
        
        dismiss(animated: true, completion: nil)
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
    
    
    
    // Adds left / right swipe-gesture recognisers to the main view
    func addGestureRecognisers() {
        
        // add left-swipe recogniser
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(processGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        // add right-swipe recogniser
        var swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(processGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    
    // Processes recognised left/right swipe recognisers
    @objc func processGesture(gesture: UIGestureRecognizer) {
        if let gesture = gesture as? UISwipeGestureRecognizer {
            switch gesture.direction {
                
            // triggers navigation back to login screen (which first checks to make sure selection has been made)
            case UISwipeGestureRecognizerDirection.right:
                leftSubtitleBarButtonPressed(gesture)
                
            // navigates to account-selection screen
            case UISwipeGestureRecognizerDirection.left:
                rightSubtitleBarButtonPressed(gesture)
            default:
                break
            }
        }
    }
    
    
    // assign fetched Admin-Report Data Set to class-level scope and call method to update charts with fetched data
    func finishedAnalysingAdminReportData(dataSet: AdminReportDataSet) {
        
        data = dataSet
        
        // hide activity indicator ow that data has loaded
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2, animations: {
            self.blurEffectView!.alpha = 0.0
        }) { (nil) in
            self.activityIndicatorBackground.isHidden = true
            self.activityIndicator.isHidden = true
            self.updateChartData()
            self.dayViewReportContainerVC.animateChart()
        }
    }
    
    
    // Gets up to date chart data and passes into report containers before notifying them to update their chart views
    func updateChartData() {
        
        guard let data = self.data else {
            // error getting data
            print ("no data")
            return
        }
        
            // pass fetched day-view data into chart's container VC
        dayViewReportContainerVC.addChartData(chartData: (
            redValues: [
                data.dayViewReds.p1,
                data.dayViewReds.p2,
                data.dayViewReds.p3,
                data.dayViewReds.l1,
                data.dayViewReds.l2,
                data.dayViewReds.p4,
                data.dayViewReds.p5,
                data.dayViewReds.p6,
                data.dayViewReds.p7],
            amberValues: [
                data.dayViewAmbers.p1,
                data.dayViewAmbers.p2,
                data.dayViewAmbers.p3,
                data.dayViewAmbers.l1,
                data.dayViewAmbers.l2,
                data.dayViewAmbers.p4,
                data.dayViewAmbers.p5,
                data.dayViewAmbers.p6,
                data.dayViewAmbers.p7],
            greenValues: [
                data.dayViewGreens.p1,
                data.dayViewGreens.p2,
                data.dayViewGreens.p3,
                data.dayViewGreens.l1,
                data.dayViewGreens.l2,
                data.dayViewGreens.p4,
                data.dayViewGreens.p5,
                data.dayViewGreens.p6,
                data.dayViewGreens.p7],
            incidentValues: [
                data.dayViewIncidents.p1,
                data.dayViewIncidents.p2,
                data.dayViewIncidents.p3,
                data.dayViewIncidents.l1,
                data.dayViewIncidents.l2,
                data.dayViewIncidents.p4,
                data.dayViewIncidents.p5,
                data.dayViewIncidents.p6,
                data.dayViewIncidents.p7]
        ))
        
        
            // pass fetched week-view data into chart's container VC
        weekViewReportContainerVC.addChartData(chartData: (
            redValues: [
                data.weekViewReds.mon,
                data.weekViewReds.tue,
                data.weekViewReds.wed,
                data.weekViewReds.thu,
                data.weekViewReds.fri],
            amberValues: [
                data.weekViewAmbers.mon,
                data.weekViewAmbers.tue,
                data.weekViewAmbers.wed,
                data.weekViewAmbers.thu,
                data.weekViewAmbers.fri],
            greenValues: [
                data.weekViewGreens.mon,
                data.weekViewGreens.tue,
                data.weekViewGreens.wed,
                data.weekViewGreens.thu,
                data.weekViewGreens.fri],
            incidentValues: [
                data.weekViewIncidents.mon,
                data.weekViewIncidents.tue,
                data.weekViewIncidents.wed,
                data.weekViewIncidents.thu,
                data.weekViewIncidents.fri]
        ))
        

            // pass fetched incident-characteristics data into chart's container VC
        incidentCharacteristicsReportContainerVC.addChatData(chartData: (
            totalIncidents: data.totalIncidents,
            averageIntensity: data.averageIncidentIntensity,
            behaviourPercentages: [
                data.behaviours.kicking,
                data.behaviours.headbutt,
                data.behaviours.hitting,
                data.behaviours.biting,
                data.behaviours.slapping,
                data.behaviours.scratching,
                data.behaviours.clothesGrabbing,
                data.behaviours.hairPulling],
            purposePercentages: [
                data.purposes.socialAttention,
                data.purposes.tangibles,
                data.purposes.escape,
                data.purposes.sensory,
                data.purposes.health,
                data.purposes.activityAvoidance,
                data.purposes.unknown]
        ))
    }
    
    
    // Sets up the subtitle labels' initial appearances and values
    func setupSubtitleLabels() {
        subtitleBarLabelMain.textColor = Constants.BLACK
        subtitleBarLabelMain.text = "General Day View"
        
        subtitleBarLabelLeft.textColor = Constants.BLUE
        subtitleBarLabelLeft.hide()
        subtitleBarArrowLeft.hide()
        
        subtitleBarLabelRight.textColor = Constants.BLUE
        subtitleBarLabelRight.text = "Week View"
        subtitleBarArrowRight.enable()
    }
    
    
    // Initialises Animation Engines for report view containers and sets initial positions
    func setupTableViews() {
        dayViewReportAnimation = AnimationEngine(layoutConstraints: [dayViewReportXAlign])
        weekViewReportAnimation = AnimationEngine(layoutConstraints: [weekViewReportXAlign])
        incidentCharacteristicsReportAnimation = AnimationEngine(layoutConstraints: [incidentCharacteristicsReportXAlign])
        
        weekViewReportAnimation.setOffScreenRight()
        incidentCharacteristicsReportAnimation.setOffScreenRight()
    }
    
    
    
    // Sets the the current view controller as delegates for each of the 3 table container views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRAGsAndIncidentsDayViewReportContainerSegue" {
            dayViewReportContainerVC = segue.destination as! RAGsAndIncidentsDayViewReportContainerVC
                // send chart data to container here...
            
        } else if segue.identifier == "showRAGsAndIncidentsWeekViewReportContainerSegue" {
            weekViewReportContainerVC = segue.destination as! RAGsAndIncidentsWeekViewReportContainerVC
                // send chart data to container here...
        } else if segue.identifier == "showIncidentCharacteristicsReportContainerSegue" {
            incidentCharacteristicsReportContainerVC = segue.destination as! IncidentCharacteristicsReportContainerVC
                // send chart data to container here...
        }
    }
    
    
    // Animates container views to the right - to give feeling of user browsing/scrolling to the left
    @IBAction func leftSubtitleBarButtonPressed(_ sender: Any) {
        // only allow user to scroll as far as the 'Day View' report container view, and disable the button momentarily to avoid multiple presses
        guard currentShowingReportCategory != .RAGsAndIncidentsDayView else { return }
        subtitleBarButtonLeft.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.subtitleBarButtonLeft.isEnabled = true })
        
        subtitleBarLabelLeft.flash(to: Constants.BLUE)
        
        switch currentShowingReportCategory {
        case .incidentCharacteristics:
            currentShowingReportCategory = .RAGsAndIncidentsWeekView
            subtitleBarLabelMain.text = "General Week View"
            subtitleBarLabelLeft.text = "Day View"
            subtitleBarLabelRight.show()
            subtitleBarLabelRight.text = "Incident\nCharacteristics"
            subtitleBarArrowRight.show()
            subtitleBarButtonRight.isEnabled = true
            
            incidentCharacteristicsReportAnimation.animateOffScreenRight()
            weekViewReportAnimation.animateOnFromScreenLeft()
            
            self.weekViewReportContainerVC.animateChart()
            
        case .RAGsAndIncidentsWeekView:
            currentShowingReportCategory = .RAGsAndIncidentsDayView
            subtitleBarLabelMain.text = "General Day View"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.subtitleBarLabelLeft.hide() })
            subtitleBarArrowLeft.hide()
            subtitleBarLabelRight.text = "Week View"
            
            weekViewReportAnimation.animateOffScreenRight()
            dayViewReportAnimation.animateOnFromScreenLeft()
            
            self.dayViewReportContainerVC.animateChart()
            
        case .RAGsAndIncidentsDayView:
            break
        }
        
    }
    
    
    // Animates container views to the left - to give feeling of user browsing/scrolling to the right
    @IBAction func rightSubtitleBarButtonPressed(_ sender: Any) {
        // only allow user to scroll as far as the 'Incident Characteristics' report container view, and disable the button momentarily to avoid multiple presses
        guard currentShowingReportCategory != .incidentCharacteristics else { return }
        subtitleBarButtonRight.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.subtitleBarButtonRight.isEnabled = true })
        
        subtitleBarLabelRight.flash(to: Constants.BLUE)
        
        switch currentShowingReportCategory {
        case .RAGsAndIncidentsDayView:
            subtitleBarLabelRight.flash(to: Constants.BLUE)
            currentShowingReportCategory = .RAGsAndIncidentsWeekView
            subtitleBarLabelMain.text = "General Week View"
            subtitleBarLabelRight.text = "Incident\nCharacteristics"
            subtitleBarLabelLeft.show()
            subtitleBarLabelLeft.text = "Day View"
            subtitleBarArrowLeft.show()
            subtitleBarButtonLeft.isEnabled = true
            
            dayViewReportAnimation.animateOffScreenLeft()
            weekViewReportAnimation.animateOnFromScreenRight()
            
            self.weekViewReportContainerVC.animateChart()
            
        case .RAGsAndIncidentsWeekView:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.subtitleBarLabelRight.hide() })
            currentShowingReportCategory = .incidentCharacteristics
            subtitleBarLabelMain.text = "Incident Characteristics"
            subtitleBarArrowRight.hide()
            subtitleBarLabelLeft.text = "Week View"
            
            weekViewReportAnimation.animateOffScreenLeft()
            incidentCharacteristicsReportAnimation.animateOnFromScreenRight()
            
            self.incidentCharacteristicsReportContainerVC.animateChart()
        case .incidentCharacteristics:
            break
        }
        
    }

    
}


// Provide constrained values for different available report categories
enum ReportCategory: String {
    case RAGsAndIncidentsDayView
    case RAGsAndIncidentsWeekView
    case incidentCharacteristics
}

