//
//  RAGVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 14/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class RAGVC: UIViewController {
    
    
    @IBAction func periodButtonPressed(_ sender: PeriodButton) {
        selectedPeriod = sender.tag
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let RAGAssessmentsVC = storyboard.instantiateViewController(withIdentifier: "RAGAssessmentsVC") as! RAGAssessmentsVC
        RAGAssessmentsVC.dateOffset = self.dateOffset
        RAGAssessmentsVC.selectedPeriod = self.selectedPeriod
        RAGAssessmentsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(RAGAssessmentsVC, animated: true)
    }
    
    @IBOutlet weak var todayDay: UILabel!
    @IBOutlet weak var todayDate: UILabel!
    @IBOutlet weak var yesterdayDay: SubtitleLabel!
    @IBOutlet weak var yesterdayDate: SubtitleLabel!
    @IBOutlet weak var tomorrowDay: SubtitleLabel!
    @IBOutlet weak var tomorrowDate: SubtitleLabel!
    @IBOutlet weak var yesterdayArrow: SubtitleBarArrowLeft!
    @IBOutlet weak var tomorrowArrow: SubtitleBarArrowRight!
    
    
    
//    @IBOutlet weak var set1period1Button: PeriodButton!
//    @IBOutlet weak var set1period2Button: PeriodButton!
//    @IBOutlet weak var set1period3Button: PeriodButton!
//    @IBOutlet weak var set1period4Button: PeriodButton!
//    @IBOutlet weak var set1period5Button: PeriodButton!
//    @IBOutlet weak var set1period6Button: PeriodButton!
//    @IBOutlet weak var set1period7Button: PeriodButton!
//    var periodSet1: [PeriodButton]!
    
    @IBOutlet weak var set1Period1Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set1Period2Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set1Period3Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set1Period4Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set1Period5Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set1Period6Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set1Period7Status: PeriodButtonStatusLabel!
    var periodSet1Statuses: [PeriodButtonStatusLabel]!
    
    @IBOutlet weak var set1PeriodsXAlign: NSLayoutConstraint!
    @IBOutlet weak var set1PeriodsWidth: NSLayoutConstraint!
    
    
    
//    @IBOutlet weak var set2period1Button: PeriodButton!
//    @IBOutlet weak var set2period2Button: PeriodButton!
//    @IBOutlet weak var set2period3Button: PeriodButton!
//    @IBOutlet weak var set2period4Button: PeriodButton!
//    @IBOutlet weak var set2period5Button: PeriodButton!
//    @IBOutlet weak var set2period6Button: PeriodButton!
//    @IBOutlet weak var set2period7Button: PeriodButton!
//    var periodSet2: [PeriodButton]!
    
//    @IBOutlet weak var set1period1XAlign: NSLayoutConstraint!
//    @IBOutlet weak var set1period2XAlign: NSLayoutConstraint!
//    @IBOutlet weak var set1period3XAlign: NSLayoutConstraint!
//    @IBOutlet weak var set1period4XAlign: NSLayoutConstraint!
//    @IBOutlet weak var set1period5XAlign: NSLayoutConstraint!
//    @IBOutlet weak var set1period6XAlign: NSLayoutConstraint!
//    @IBOutlet weak var set1period7XAlign: NSLayoutConstraint!
    
    @IBOutlet weak var set2Period1Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period2Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period3Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period4Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period5Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period6Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period7Status: PeriodButtonStatusLabel!
    var periodSet2Statuses: [PeriodButtonStatusLabel]!
    
    @IBOutlet weak var set2PeriodsXAlign: NSLayoutConstraint!
    @IBOutlet weak var set2PeriodsWidth: NSLayoutConstraint!
    
    //    @IBOutlet weak var set2period1XAlign: NSLayoutConstraint!
//    @IBOutlet weak var set2period2XAlign: NSLayoutConstraint!
//    @IBOutlet weak var set2period3XAlign: NSLayoutConstraint!
//    @IBOutlet weak var set2period4XAlign: NSLayoutConstraint!
//    @IBOutlet weak var set2period5XAlign: NSLayoutConstraint!
//    @IBOutlet weak var set2period6XAlign: NSLayoutConstraint!
//    @IBOutlet weak var set2period7XAlign: NSLayoutConstraint!
    
    
    var set1PeriodsAnimation: AnimationEngine?
    var set2PeriodsAnimation: AnimationEngine?
    
    @IBOutlet weak var yesterdayButton: SubtitleBarButton!
    @IBOutlet weak var tomorrowButton: SubtitleBarButton!

    @IBAction func yesterdayButtonPressed(_ sender: Any) {
        yesterdayButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.yesterdayButton.isEnabled = true })
        
        guard days != nil else { return }
        guard -dateOffset < (days?.count)! - 1 else { return }
        
        if dateOffset == 0 {
            tomorrowDay.enable()
            tomorrowDate.enable()
            tomorrowArrow.enable()
        }
        yesterdayDay.flash(to: Constants.SUBTITLE_BAR_BLUE)
        yesterdayDate.flash(to: Constants.SUBTITLE_BAR_BLUE)
        dateOffset -= 1
        refreshDateLabels()
        
        if loadPeriodsForSet1 {
            updateStatus(for: periodSet1Statuses)
            set1PeriodsAnimation?.setOffScreenLeft()
            set1PeriodsAnimation?.animateOnFromScreenLeft()
            set2PeriodsAnimation?.animateOffScreenRight()
        } else {
            updateStatus(for: periodSet2Statuses)
            set2PeriodsAnimation?.setOffScreenLeft()
            set2PeriodsAnimation?.animateOnFromScreenLeft()
            set1PeriodsAnimation?.animateOffScreenRight()
        }
        loadPeriodsForSet1 = !loadPeriodsForSet1
        
        
    }
    @IBAction func tomorrowButtonPressed(_ sender: Any) {
        tomorrowButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.tomorrowButton.isEnabled = true })
        if dateOffset < 0 {
            if dateOffset == -1 {
                tomorrowDay.disable()
                tomorrowDate.disable()
                tomorrowArrow.disable()
                tomorrowDay.flash(to: Constants.SUBTITLE_BAR_GRAY)
                tomorrowDate.flash(to: Constants.SUBTITLE_BAR_GRAY)
            } else {
                tomorrowDay.flash(to: Constants.SUBTITLE_BAR_BLUE)
                tomorrowDate.flash(to: Constants.SUBTITLE_BAR_BLUE)
            }
            dateOffset += 1
            refreshDateLabels()
            
            if loadPeriodsForSet1 {
                updateStatus(for: periodSet1Statuses)
                set1PeriodsAnimation?.setOffScreenRight()
                set1PeriodsAnimation?.animateOnFromScreenRight()
                set2PeriodsAnimation?.animateOffScreenLeft()
            } else {
                updateStatus(for: periodSet2Statuses)
                set2PeriodsAnimation?.setOffScreenRight()
                set2PeriodsAnimation?.animateOnFromScreenRight()
                set1PeriodsAnimation?.animateOffScreenLeft()
            }
            loadPeriodsForSet1 = !loadPeriodsForSet1
        }
    }
    
    var dateOffset = 0
    var loadPeriodsForSet1 = true
    var selectedPeriod: Int?
    
    var days: [DayRAGs]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        periodSet1Statuses = [set1Period1Status, set1Period2Status, set1Period3Status, set1Period4Status, set1Period5Status, set1Period6Status, set1Period7Status]
       
        periodSet2Statuses = [set2Period1Status, set2Period2Status, set2Period3Status, set2Period4Status, set2Period5Status, set2Period6Status, set2Period7Status]
        
//        periodSet1 = [set1period1Button, set1period2Button, set1period3Button, set1period4Button, set1period5Button, set1period6Button, set1period7Button]
//        addButtonTitles(for: periodSet1)
//
//        periodSet2 = [set2period1Button, set2period2Button, set2period3Button, set2period4Button, set2period5Button, set2period6Button, set2period7Button]
//        addButtonTitles(for: periodSet2)
        
        
        days = Data.getDays()

        view.layer.backgroundColor = Constants.RAG_SCREEN_COLOR.cgColor

        self.navigationItem.title = "RAG"
        
//        set1PeriodsAnimation = AnimationEngine(layoutConstraints: [set1period1XAlign, set1period2XAlign, set1period3XAlign, set1period4XAlign, set1period5XAlign, set1period6XAlign, set1period7XAlign])
        set1PeriodsAnimation = AnimationEngine(layoutConstraints: [set1PeriodsXAlign])
        set2PeriodsAnimation = AnimationEngine(layoutConstraints: [set2PeriodsXAlign])
//        set2PeriodsAnimation = AnimationEngine(layoutConstraints: [set2period1XAlign, set2period2XAlign, set2period3XAlign, set2period4XAlign, set2period5XAlign, set2period6XAlign, set2period7XAlign])
        
        updateStatus(for: periodSet1Statuses)
        set2PeriodsAnimation?.setOffScreenLeft()
        loadPeriodsForSet1 = !loadPeriodsForSet1
        
        refreshDateLabels()
        addLogoutButton()
    }
    
    @objc func logoutButtonPressed() {
        
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        } ))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            self.performSegue(withIdentifier: "unwindRAGVCToLoginVCSegue", sender: self)
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
    
    
    
//    func addButtonTitles(for set: [PeriodButton]) {
//        for i in 1...set.count {
//            set[i-1].setTitle("Period \(i)", for: .normal)
//        }
//    }
    
    func updateStatus(for set: [PeriodButtonStatusLabel]) {
        guard days != nil else { return }
        let now = Date()
        
        if days![-dateOffset].p1 == 1 {
            set[0].setStatusComplete()
        } else if dateOffset < 0 || now > now.dateAt(hours: Constants.P1_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P1_END_MINS) {
            set[0].setStatusNotComplete()
        }
        
        if days![-dateOffset].p2 == 1 {
            set[1].setStatusComplete()
        } else if dateOffset < 0 || now > now.dateAt(hours: Constants.P2_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P2_END_MINS) {
            set[1].setStatusNotComplete()
        }
        
        if days![-dateOffset].p3 == 1 {
            set[2].setStatusComplete()
        } else if dateOffset < 0 || now > now.dateAt(hours: Constants.P3_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P3_END_MINS) {
            set[2].setStatusNotComplete()
        }
        
        if days![-dateOffset].p4 == 1 {
            set[3].setStatusComplete()
        } else if dateOffset < 0 || now > now.dateAt(hours: Constants.P4_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P4_END_MINS) {
            set[3].setStatusNotComplete()
        }
        
        if days![-dateOffset].p5 == 1 {
            set[4].setStatusComplete()
        } else if dateOffset < 0 || now > now.dateAt(hours: Constants.P5_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P5_END_MINS) {
            set[4].setStatusNotComplete()
        }
        
        if days![-dateOffset].p6 == 1 {
            set[5].setStatusComplete()
        } else if dateOffset < 0 || now > now.dateAt(hours: Constants.P6_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P6_END_MINS) {
            set[5].setStatusNotComplete()
        }
        
        if days![-dateOffset].p7 == 1 {
            set[6].setStatusComplete()
        } else if dateOffset < 0 || now > now.dateAt(hours: Constants.P7_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P7_END_MINS) {
            set[6].setStatusNotComplete()
        }
        
        
    }
    

    func refreshDateLabels() {
        
        todayDay.text = Data.getDayString(for: dateOffset)
        yesterdayDay.text = Data.getDayString(for: dateOffset - 1)
        tomorrowDay.text = Data.getDayString(for: dateOffset + 1)
        
        todayDate.text = Data.getDateString(for: dateOffset)
        yesterdayDate.text = Data.getDateString(for: dateOffset - 1)
        tomorrowDate.text = Data.getDateString(for: dateOffset + 1)
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
            
            self.set1PeriodsWidth.constant = self.view.frame.size.width - 28
            self.set2PeriodsWidth.constant = self.view.frame.size.width - 28
            
        })
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.set1PeriodsWidth.constant = self.view.frame.size.width - 28
        self.set2PeriodsWidth.constant = self.view.frame.size.width - 28
    }
    
    
    
}
