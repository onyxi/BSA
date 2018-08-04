//
//  AdminReportsDataVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 18/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class AdminReportsDataVC: UIViewController, AdminReportAnalysisDelegate {
    
    
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
        
        setupSubtitleLabels()
        setupTableViews()
        
        dataService = DataService()
        
        
        analysis = AdminReportAnalysis()
        analysis?.adminReportAnalysisDelegate = self
        analysis?.analyseAdminReportData(for: studentSelection)
        
//        getData()
        
    }
    
    
    
    func finishedAnalysingAdminReportData(dataSet: AdminReportDataSet) {
        data = dataSet
        updateChartData()
    }
    
    
 
    
    func getData() {
//        if let retrievedData = Data.getAdminReportData(for: studentSelection) {
//                // assign retreived data object for use
//            data = retrievedData
//            updateChartData()
//        } else {
//                // show alert to inform that there was an error getting data
//            let alert = UIAlertController(title: "Data Error", message: "There was a problem getting report data. Check your network connection.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
//                alert.dismiss(animated: true, completion: nil)
//            }))
//            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
//                alert.dismiss(animated: true, completion: nil)
//                self.getData()
//            }))
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
    }
    
    // Gets up to date chart data and passes into report containers before notifying them to update their chart views
    func updateChartData() {
        
        guard let data = self.data else {
            // error getting data
            print ("no data")
            return
        }
        
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
        subtitleBarLabelMain.text = "Day View"
        
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
            subtitleBarLabelMain.text = "Week View"
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
            subtitleBarLabelMain.text = "Day View"
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
            subtitleBarLabelMain.text = "Week View"
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

