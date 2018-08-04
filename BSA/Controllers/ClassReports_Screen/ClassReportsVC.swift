//
//  ClassReportsVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 01/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class ClassReportsVC: UIViewController, SchoolClassFetchingDelegate, ClassReportAnalysisDelegate {
    
    
    // UI handles:
    @IBOutlet weak var topChartsTitleLabel: UILabel!
    @IBOutlet weak var bottomChartsTitleLabel: UILabel!

    @IBOutlet weak var topChart1Legend: UILabel!
    @IBOutlet weak var topChart1Reds: ReportItem!
    @IBOutlet weak var topChart1Ambers: ReportItem!
    @IBOutlet weak var topChart1Greens: ReportItem!
    
    @IBOutlet weak var topChart2Legend1: UILabel!
    @IBOutlet weak var topChart2IntensityChart: IntensityIndicator!
    @IBOutlet weak var topChart2Legend2: UILabel!
    @IBOutlet weak var topChart2IncidentLikelihoodItem: ReportItem!
    
    @IBOutlet weak var bottomChart1Legend: UILabel!
    @IBOutlet weak var bottomChart1Reds: ReportItem!
    @IBOutlet weak var bottomChart1Ambers: ReportItem!
    @IBOutlet weak var bottomChart1Greens: ReportItem!
    
    @IBOutlet weak var bottomChart2Legend1: UILabel!
    @IBOutlet weak var bottomChart2IntensityChart: IntensityIndicator!
    @IBOutlet weak var bottomChart2Legend2: UILabel!
    @IBOutlet weak var bottomChart2IncidentLikelihoodItem: ReportItem!
    
    
    // Properties:
    var schoolClass: SchoolClass?
//    var classStudents: [Student]?
    var topChartsData: ClassReportDataSet?
    var bottomChartsData: ClassReportDataSet?
    
    var topChartTimePeriod = TimePeriod.currentWeek
    var bottomChartTimePeriod = TimePeriod.allTime
    
    var dataService: DataService?
//    var analysis: Analysis?
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()

            // set color and title
        view.layer.backgroundColor = Constants.CLASS_REPORTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Reports"
        
            // set up logout button
        addLogoutButton()
        
        
        dataService = DataService()
        dataService?.schoolClassFetchingDelegate = self
        
        
        dataService?.getSchoolClass(withId: UserDefaults.standard.string(forKey: Constants.LOGGED_IN_ACCOUNT_CLASS_ID)!)
        
            // retrieve data for charts from storage
//        getClass()
//        retrieveAndUnpackChartData()
        
        // for testing...
//        schoolClass = Data.getSchoolClass(numbered: UserDefaults.standard.integer(forKey: Constants.LOGGED_IN_ACCOUNT_NUMBER_KEY))
//
//        if schoolClass != nil {
//            topChartsData = Data.getClassReportData(for: schoolClass!, from: .currentWeek)
//                    bottomChartsData = Data.getClassReportData(for: schoolClass!, from: .lastWeek)
//
//            setupTopCharts()
//            setupBottomCharts()
//        }
    }
    
    

    func finishedFetching(schoolClasses: [SchoolClass]) {
        
        // dispatch group...
        let topChartsAnalysis = ClassReportAnalysis()
        topChartsAnalysis.classReportAnalysisDelegate = self
        topChartsAnalysis.analyseClassReportData(for: schoolClasses[0], from: topChartTimePeriod)
        
        let bottomChartsAnalysis = ClassReportAnalysis()
        bottomChartsAnalysis.classReportAnalysisDelegate = self
        bottomChartsAnalysis.analyseClassReportData(for: schoolClasses[0], from: bottomChartTimePeriod)
        /// resume...
        //  setupTopCharts()
        //  setupBottomCharts()
    }
    
    func finishedAnalysingClassReportData(dataSet: ClassReportDataSet, for timePeriod: TimePeriod) {
        if timePeriod == topChartTimePeriod {
            topChartsData = dataSet
            setupTopCharts()
        } else {
            bottomChartsData = dataSet
            setupBottomCharts()
        }
        
//        switch timePeriod{
//        case .today:
//            topChartsData = dataSet
//            setupTopCharts()
//        default:
//            bottomChartsData = dataSet
//            setupBottomCharts()
//        }
    }
    
    
//    func getClass() {
    
        
//        if let schoolClass = Data.getSchoolClass(numbered: UserDefaults.standard.integer(forKey: Constants.LOGGED_IN_ACCOUNT_NUMBER_KEY)) {
//            self.schoolClass = schoolClass
////            classStudents = Data.getStudents(for: schoolClass)
//        } else {
//            // failed to get school class
//             print ("failed to get school class")
//        }
//    }
    
//    func retrieveAndUnpackChartData() {
//        guard schoolClass != nil else {
//            // no schoolClass data
//            print ("no schoolClass data")
//            return
//        }
//
//        if let dataSet1 = Data.getClassReportData(for: schoolClass!, from: topChartTimePeriod) {
//            topChartsData = dataSet1
//            setupTopCharts()
//        } else {
//            // problem getting data
//            print("error getting data set 1 for class reports")
//        }
//
//        if let dataSet2 = Data.getClassReportData(for: schoolClass!, from: bottomChartTimePeriod) {
//            bottomChartsData = dataSet2
//            setupBottomCharts()
//        } else {
//            // problem getting data
//            print("error getting data set 1 for class reports")
//        }
//
//    }
    
    
    // Adds a configured logout button to the navigation bar
    func addLogoutButton() {
        let logoutButton = UIButton(type: .system)
        logoutButton.setImage(UIImage(named: "logoutButton"), for: .normal)
        logoutButton.setTitle("  Log-Out", for: .normal)
        logoutButton.sizeToFit()
        logoutButton.addTarget(self, action: #selector(self.logoutButtonPressed), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
    }
    

    // Logs out the user and segue's to the app's initial login screen
    @objc func logoutButtonPressed() {
            // present alert to make sure the user want to actually wants to log out
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        } ))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                // remove record of logged in account and segue to login screen
//            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_NUMBER_KEY)
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_ID)
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_NAME)
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_SECURITY_LEVEL)
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_CLASS_ID)
            self.performSegue(withIdentifier: "unwindClassReportsVCToLoginVCSegue", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Immediately before the view appears, sets the chart data visual representations to animate
    override func viewDidAppear(_ animated: Bool) {
        
            // top chart 1
        topChart1Reds.animateColumn()
        topChart1Ambers.animateColumn()
        topChart1Greens.animateColumn()

            // top chart 2
        if topChartsData != nil {
            topChart2IntensityChart.animateIntensity(to: topChartsData!.averageIntensity)
        }
        
            // bottom chart 1
        bottomChart1Reds.animateColumn()
        bottomChart1Ambers.animateColumn()
        bottomChart1Greens.animateColumn()
//        print(bottomChartsData!.averageIntensity)
            // bottom chart 2
        if bottomChartsData != nil {
            bottomChart2IntensityChart.animateIntensity(to: bottomChartsData!.averageIntensity)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // top chart 1
        topChart1Reds.resetColumn()
        topChart1Ambers.resetColumn()
        topChart1Greens.resetColumn()

        // top chart 2
        topChart2IntensityChart.intensity = 0.0
        
        // bottom chart 1
        bottomChart1Reds.resetColumn()
        bottomChart1Ambers.resetColumn()
        bottomChart1Greens.resetColumn()

        // bottom chart 2
        bottomChart2IntensityChart.intensity = 0.0
    }

    // Configures the 2 charts at the top of the view
    func setupTopCharts() {
        
            // set main title
        topChartsTitleLabel.text = "\(topChartsData!.entityName!) - \(topChartsData!.timePeriod!)"
        
            // set chart 1 Reds data
        topChart1Legend.text = "Average Spread of\nRed, Amber and Green Assessments Given"
        topChart1Reds.setType(to: .reds)
        topChart1Reds.setValue(to: topChartsData!.averageReds)
        topChart1Reds.showColumn()
        
            // set chart 1 Ambers data
        topChart1Ambers.setType(to: .ambers)
        topChart1Ambers.setValue(to: topChartsData!.averageAmbers)
        topChart1Ambers.showColumn()
        
            // set chart 1 Greens data
        topChart1Greens.setType(to: .greens)
        topChart1Greens.setValue(to: topChartsData!.averageGreens)
        topChart1Greens.showColumn()
        
            // set chart 2 legends and data
        topChart2Legend1.text = "Average Intensity of Incidents"
        topChart2IntensityChart.animateIntensity(to: topChartsData!.averageIntensity)
        topChart2Legend2.text = "Likelihood of an Incident Occurring in Any Period"
        topChart2IncidentLikelihoodItem.setType(to: .incidents)
        topChart2IncidentLikelihoodItem.setValue(to: topChartsData!.likelihoodOfIncident)

    }
    
    
    // Configures the 2 charts at the bottom of the view
    func setupBottomCharts() {
        
            // set main title
        bottomChartsTitleLabel.text = "\(bottomChartsData!.entityName!) - \(bottomChartsData!.timePeriod!)"
        
            // set chart 1 Reds data
        bottomChart1Legend.text = "Average Spread of\nRed, Amber and Green Assessments Given"
        bottomChart1Reds.setType(to: .reds)
        bottomChart1Reds.setValue(to: bottomChartsData!.averageReds)
        bottomChart1Reds.showColumn()
        
            // set chart 1 Ambers data
        bottomChart1Ambers.setType(to: .ambers)
        bottomChart1Ambers.setValue(to: bottomChartsData!.averageAmbers)
        bottomChart1Ambers.showColumn()
        
            // set chart 1 Greens data
        bottomChart1Greens.setType(to: .greens)
        bottomChart1Greens.setValue(to: bottomChartsData!.averageGreens)
        bottomChart1Greens.showColumn()
        
            // set chart 2 legends and data
        bottomChart2Legend1.text = "Average Intensity of Incidents"
        bottomChart2IntensityChart.animateIntensity(to: bottomChartsData!.averageIntensity)
        bottomChart2Legend2.text = "Likelihood of an Incident Occurring in Any Period"
        bottomChart2IncidentLikelihoodItem.setType(to: ReportItemType.incidents)
        bottomChart2IncidentLikelihoodItem.setValue(to: bottomChartsData!.likelihoodOfIncident)
        
    }
    
    
    // Reloads intensity charts data when the view is rotated - to accomodate different device orientations
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
            if self.topChartsData != nil && self.bottomChartsData != nil {
                self.topChart2IntensityChart.intensity = self.topChartsData!.averageIntensity
                self.bottomChart2IntensityChart.intensity = self.bottomChartsData!.averageIntensity
            }
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    

}
