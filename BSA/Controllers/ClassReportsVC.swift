//
//  ClassReportsVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 01/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class ClassReportsVC: UIViewController {
    
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
    
    var schoolClass: SchoolClass?
    
    var topChartsData: ClassReportDataSet?
    var bottomChartsData: ClassReportDataSet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.layer.backgroundColor = Constants.CLASS_REPORTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Reports"
        
        addLogoutButton()
        
        configureTabBar()
        
        // for testing...
        schoolClass = Data.getSchoolClass(named: "Class C")
        if schoolClass != nil {
            topChartsData = Data.getReportData(for: schoolClass!, from: .currentWeek)
            bottomChartsData = Data.getReportData(for: schoolClass!, from: .lastWeek)
            
            setupTopCharts()
            setupBottomCharts()
        }
    }
    
    func configureTabBar() {
        
    }

    
    @objc func logoutButtonPressed() {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        } ))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            self.performSegue(withIdentifier: "unwindClassReportsVCToLoginVCSegue", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addLogoutButton() {
        let logoutButton = UIButton(type: .system)
        logoutButton.setImage(UIImage(named: "logoutButton"), for: .normal)
        logoutButton.setTitle("  Log-Out", for: .normal)
        logoutButton.sizeToFit()
        logoutButton.addTarget(self, action: #selector(self.logoutButtonPressed), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        topChart1Reds.animateColumn()
        topChart1Ambers.animateColumn()
        topChart1Greens.animateColumn()
        
//        topChart2IntensityChart.intensity = 0.0
        topChart2IntensityChart.animateIntensity(to: topChartsData!.averageIntensity)
        
        bottomChart1Reds.animateColumn()
        bottomChart1Ambers.animateColumn()
        bottomChart1Greens.animateColumn()
        
//        bottomChart2IntensityChart.intensity = 0.0
        bottomChart2IntensityChart.animateIntensity(to: bottomChartsData!.averageIntensity)
        
    }

    func setupTopCharts() {
        
        topChartsTitleLabel.text = "\(topChartsData!.entityName!) - \(topChartsData!.timePeriod!)"
        
        topChart1Legend.text = "Average Spread of\nRed, Amber and Green Assessments Given"
        topChart1Reds.setType(to: .reds)
        topChart1Reds.setValue(to: topChartsData!.averageReds)
        topChart1Reds.showColumn()
        
        topChart1Ambers.setType(to: .ambers)
        topChart1Ambers.setValue(to: topChartsData!.averageAmbers)
        topChart1Ambers.showColumn()
        
        topChart1Greens.setType(to: .greens)
        topChart1Greens.setValue(to: topChartsData!.averageGreens)
        topChart1Greens.showColumn()
        
        
        topChart2Legend1.text = "Average Intensity of Incidents"
        
        
        topChart2Legend2.text = "Likelihood of an Incident Occurring in Any Period"
        topChart2IncidentLikelihoodItem.setType(to: .incidents)
        topChart2IncidentLikelihoodItem.setValue(to: topChartsData!.likelihoodOfIncident)
    }
    
    func setupBottomCharts() {
        bottomChartsTitleLabel.text = "\(bottomChartsData!.entityName!) - \(bottomChartsData!.timePeriod!)"
        
        bottomChart1Legend.text = "Average Spread of\nRed, Amber and Green Assessments Given"
        bottomChart1Reds.setType(to: .reds)
        bottomChart1Reds.setValue(to: bottomChartsData!.averageReds)
        bottomChart1Reds.showColumn()
        
        bottomChart1Ambers.setType(to: .ambers)
        bottomChart1Ambers.setValue(to: bottomChartsData!.averageAmbers)
        bottomChart1Ambers.showColumn()
        
        bottomChart1Greens.setType(to: .greens)
        bottomChart1Greens.setValue(to: bottomChartsData!.averageGreens)
        bottomChart1Greens.showColumn()
        
        
        bottomChart2Legend1.text = "Average Intensity of Incidents"
        
        
        bottomChart2Legend2.text = "Likelihood of an Incident Occurring in Any Period"
        bottomChart2IncidentLikelihoodItem.setType(to: ReportItemType.incidents)
        bottomChart2IncidentLikelihoodItem.setValue(to: bottomChartsData!.likelihoodOfIncident)
        
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
            if self.topChartsData != nil && self.bottomChartsData != nil {
                self.topChart2IntensityChart.intensity = self.topChartsData!.averageIntensity
                self.bottomChart2IntensityChart.intensity = self.bottomChartsData!.averageIntensity
            }
        })
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    

}
