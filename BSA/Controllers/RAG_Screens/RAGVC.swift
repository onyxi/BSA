//
//  RAGVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 14/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit
import UserNotifications

class RAGVC: UIViewController, UNUserNotificationCenterDelegate, SchoolClassFetchingDelegate, StudentFetchingDelegate, RAGAssessmentsFetchingDelegate {
    
    // UI handles:
    @IBOutlet weak var todayDay: UILabel!
    @IBOutlet weak var todayDate: UILabel!
    @IBOutlet weak var yesterdayDay: SubtitleLabel!
    @IBOutlet weak var yesterdayDate: SubtitleLabel!
    @IBOutlet weak var tomorrowDay: SubtitleLabel!
    @IBOutlet weak var tomorrowDate: SubtitleLabel!
    @IBOutlet weak var yesterdayArrow: SubtitleBarArrowLeft!
    @IBOutlet weak var tomorrowArrow: SubtitleBarArrowRight!
    
    @IBOutlet weak var set1Period1Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set1Period2Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set1Period3Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set1Period4Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set1Period5Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set1Period6Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set1Period7Status: PeriodButtonStatusLabel!
    var periodSet1Statuses: [PeriodButtonStatusLabel]!
    
    @IBOutlet weak var set1PeriodsXAlign: NSLayoutConstraint!
    
    @IBOutlet weak var set2Period1Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period2Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period3Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period4Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period5Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period6Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period7Status: PeriodButtonStatusLabel!
    var periodSet2Statuses: [PeriodButtonStatusLabel]!
    
    @IBOutlet weak var set2PeriodsXAlign: NSLayoutConstraint!
    
    @IBOutlet weak var yesterdayButton: SubtitleBarButton!
    @IBOutlet weak var tomorrowButton: SubtitleBarButton!
    
    @IBOutlet weak var activityIndicatorBackground: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var blurEffectView: UIView?
    
    // Properties:
    var set1PeriodsAnimation: AnimationEngine?
    var set2PeriodsAnimation: AnimationEngine?
    var dateOffset = 0
    var loadPeriodsForSet1 = true
    var classStudents: [Student]?
    var rAGAssessments: [RAGAssessment]?
    
    var dataService: DataService?
    
    var day1RAGs = [(period: String, rAGAssessments: [RAGAssessment])]()
    var day2RAGs = [(period: String, rAGAssessments: [RAGAssessment])]()
    var day3RAGs = [(period: String, rAGAssessments: [RAGAssessment])]()
    var day4RAGs = [(period: String, rAGAssessments: [RAGAssessment])]()
    var day5RAGs = [(period: String, rAGAssessments: [RAGAssessment])]()
    var day6RAGs = [(period: String, rAGAssessments: [RAGAssessment])]()
    var day7RAGs = [(period: String, rAGAssessments: [RAGAssessment])]()
    

    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // set VC color and title, and add logout button
        view.layer.backgroundColor = Constants.RAG_SCREEN_COLOR.cgColor
        self.navigationItem.title = "RAG"
        addLogoutButton()
        
            // update the subtitle's 'date' button labels (and arrow views) - to reflect the initial date (with offset 0 = today)
        refreshDateLabels()
        tomorrowArrow.disable()
        
            // assign 1st array of period buttons - to make updating each one more efficient
        periodSet1Statuses = [set1Period1Status, set1Period2Status, set1Period3Status, set1Period4Status, set1Period5Status, set1Period6Status, set1Period7Status]
        
            // assign 2nd array of period buttons - to make updating each one more efficient
        periodSet2Statuses = [set2Period1Status, set2Period2Status, set2Period3Status, set2Period4Status, set2Period5Status, set2Period6Status, set2Period7Status]
        
            // initialise animation engines for the 2 sets of period buttons - and position appropriately
        set1PeriodsAnimation = AnimationEngine(layoutConstraints: [set1PeriodsXAlign])
        set2PeriodsAnimation = AnimationEngine(layoutConstraints: [set2PeriodsXAlign])
        set2PeriodsAnimation?.setOffScreenLeft()
        
            // initialise DataService and request from storage the School Class object for logged-in user
        dataService = DataService()
        dataService?.schoolClassFetchingDelegate = self
        dataService?.studentFetchingDelegate = self
        dataService?.rAGAssessmentsFetchingDelegate = self
        dataService?.getSchoolClass(withId: UserDefaults.standard.string(forKey: Constants.LOGGED_IN_ACCOUNT_CLASS_ID)!)
        
            // initialse arrays to hold retrieved RAG Assessment data
        setupRAGAssessmentArrays()
        
            // add swipe-gesture recognisers to main view
        addGestureRecognisers()
       
            // add blur while data loads
        setupActivityIndicator()
        
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
                yesterdayButtonPressed(gesture)
                
            // navigates to account-selection screen
            case UISwipeGestureRecognizerDirection.left:
                tomorrowButtonPressed(gesture)
            default:
                break
            }
        }
    }
    
    
    
    // Requests all School Class objects every time the view is displayed
    override func viewDidAppear(_ animated: Bool) {
        dataService?.getSchoolClass(withId: UserDefaults.standard.string(forKey: Constants.LOGGED_IN_ACCOUNT_CLASS_ID)!)
    }

    // Requests Students associated with fetched School Class object
    func finishedFetching(schoolClasses: [SchoolClass]) {
        dataService?.getStudents(for: schoolClasses[0])
    }
    
    // Assigns fetched Students to class-level scope and requests RAG Assessment objects associated with them
    func finishedFetching(students: [Student]) {
        classStudents = students
        dataService?.getRAGAssessments(for: students, fromTimePeriod: .allTime)
    }
    
    // Assigns fetched RAG Assessments to class-level scope and calls method to unpack fetched data for display in views
    func finishedFetching(rAGAssessments: [RAGAssessment]) {
        self.rAGAssessments = rAGAssessments
        retrieveAndUnpackRAGAssessments()
    }
    
    
    // Initialises arrays to hold RAG Assessment data
    func setupRAGAssessmentArrays() {
        day1RAGs = [
            (period: Constants.SCHOOL_DAY_PERIODS.p1, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p2, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p3, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p4, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p5, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p6, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p7, rAGAssessments: [RAGAssessment]())]
        day2RAGs = [
            (period: Constants.SCHOOL_DAY_PERIODS.p1, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p2, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p3, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p4, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p5, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p6, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p7, rAGAssessments: [RAGAssessment]())]
        day3RAGs = [
            (period: Constants.SCHOOL_DAY_PERIODS.p1, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p2, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p3, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p4, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p5, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p6, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p7, rAGAssessments: [RAGAssessment]())]
        day4RAGs = [
            (period: Constants.SCHOOL_DAY_PERIODS.p1, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p2, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p3, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p4, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p5, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p6, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p7, rAGAssessments: [RAGAssessment]())]
        day5RAGs = [
            (period: Constants.SCHOOL_DAY_PERIODS.p1, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p2, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p3, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p4, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p5, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p6, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p7, rAGAssessments: [RAGAssessment]())]
        day6RAGs = [
            (period: Constants.SCHOOL_DAY_PERIODS.p1, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p2, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p3, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p4, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p5, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p6, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p7, rAGAssessments: [RAGAssessment]())]
        day7RAGs = [
            (period: Constants.SCHOOL_DAY_PERIODS.p1, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p2, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p3, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p4, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p5, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p6, rAGAssessments: [RAGAssessment]()),
            (period: Constants.SCHOOL_DAY_PERIODS.p7, rAGAssessments: [RAGAssessment]())]
    }
    
    
    // Unpacks fetched data for display in views
    func retrieveAndUnpackRAGAssessments() {
        
            // check that required Students data has been retrieved
        guard classStudents != nil else {
            // failed to get class students
            print ("failed to get class students")
            return
        }
        
            // check that required RAG Assessments data has been retrieved
        guard rAGAssessments != nil else {
            // failed to get RAG Assessments
            print ("failed to get RAG Assessments")
            return
        }
        
        // hide activity indicator ow that data is loaded
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2, animations: {
            self.blurEffectView!.alpha = 0.0
        }) { (nil) in
            self.activityIndicatorBackground.isHidden = true
            self.activityIndicator.isHidden = true
        }
 
            // sort RAG Assessments into their respective days and periods
        for rag in rAGAssessments! {
            switch rag.date {
            case Date().withOffset(dateOffset: 0):
                switch rag.period {
                case Constants.SCHOOL_DAY_PERIODS.p1 :
                    day1RAGs[0].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p2:
                    day1RAGs[1].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p3:
                    day1RAGs[2].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p4:
                    day1RAGs[3].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p5:
                    day1RAGs[4].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p6:
                    day1RAGs[5].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p7:
                    day1RAGs[6].rAGAssessments.append(rag)
                default:
                    break
                }
            case Date().withOffset(dateOffset: -1):
                switch rag.period {
                case Constants.SCHOOL_DAY_PERIODS.p1 :
                    day2RAGs[0].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p2:
                    day2RAGs[1].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p3:
                    day2RAGs[2].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p4:
                    day2RAGs[3].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p5:
                    day2RAGs[4].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p6:
                    day2RAGs[5].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p7:
                    day2RAGs[6].rAGAssessments.append(rag)
                default:
                    break
                }
            case Date().withOffset(dateOffset: -2):
                switch rag.period {
                case Constants.SCHOOL_DAY_PERIODS.p1 :
                    day3RAGs[0].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p2:
                    day3RAGs[1].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p3:
                    day3RAGs[2].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p4:
                    day3RAGs[3].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p5:
                    day3RAGs[4].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p6:
                    day3RAGs[5].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p7:
                    day3RAGs[6].rAGAssessments.append(rag)
                default:
                    break
                }
            case Date().withOffset(dateOffset: -3):
                switch rag.period {
                case Constants.SCHOOL_DAY_PERIODS.p1 :
                    day4RAGs[0].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p2:
                    day4RAGs[1].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p3:
                    day4RAGs[2].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p4:
                    day4RAGs[3].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p5:
                    day4RAGs[4].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p6:
                    day4RAGs[5].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p7:
                    day4RAGs[6].rAGAssessments.append(rag)
                default:
                    break
                }
            case Date().withOffset(dateOffset: -4):
                switch rag.period {
                case Constants.SCHOOL_DAY_PERIODS.p1 :
                    day5RAGs[0].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p2:
                    day5RAGs[1].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p3:
                    day5RAGs[2].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p4:
                    day5RAGs[3].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p5:
                    day5RAGs[4].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p6:
                    day5RAGs[5].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p7:
                    day5RAGs[6].rAGAssessments.append(rag)
                default:
                    break
                }
            case Date().withOffset(dateOffset: -5):
                switch rag.period {
                case Constants.SCHOOL_DAY_PERIODS.p1 :
                    day6RAGs[0].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p2:
                    day6RAGs[1].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p3:
                    day6RAGs[2].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p4:
                    day6RAGs[3].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p5:
                    day6RAGs[4].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p6:
                    day6RAGs[5].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p7:
                    day6RAGs[6].rAGAssessments.append(rag)
                default:
                    break
                }
            case Date().withOffset(dateOffset: -6):
                switch rag.period {
                case Constants.SCHOOL_DAY_PERIODS.p1:
                    day7RAGs[0].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p2:
                    day7RAGs[1].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p3:
                    day7RAGs[2].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p4:
                    day7RAGs[3].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p5:
                    day7RAGs[4].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p6:
                    day7RAGs[5].rAGAssessments.append(rag)
                case Constants.SCHOOL_DAY_PERIODS.p7:
                    day7RAGs[6].rAGAssessments.append(rag)
                default:
                    break
                }
            default:
                break
            }
        }
        
        // update statuses for the period buttons to be shown first
        updateStatus(for: periodSet1Statuses)
        
        // invert flag for next set of periods buttons to be updated (to indicate set 2 will be shown next)
        loadPeriodsForSet1 = !loadPeriodsForSet1
    }
    
    
    
    
    // Scrolls the period buttons to the right to show period-status data for previous day.
    @IBAction func yesterdayButtonPressed(_ sender: Any) {
        
            // disable the 'yesterday' button momentarily to stop multiple repeat presses
        yesterdayButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.yesterdayButton.isEnabled = true })
        
        guard dateOffset > -6 else { return }
        
            // enable the 'tomorrow' button if previously disabled
        if dateOffset == 0 {
            tomorrowDay.enable()
            tomorrowDate.enable()
            tomorrowArrow.enable()
        }
        
            // flash the yesterday button's associated labels to give visual feedback to user
        yesterdayDay.flash(to: Constants.BLUE)
        yesterdayDate.flash(to: Constants.BLUE)
        
            // update 'dateOffset' flag - to reflect number of days into the past that the view should display, and update the subtitle's date labels accordingly
        dateOffset -= 1
        refreshDateLabels()
        
            // update status labels for next set of period buttons due to be updated, and then animate: current set off-screen, due set on-screen
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
        
            // invert flag for next set of periods buttons to be updated
        loadPeriodsForSet1 = !loadPeriodsForSet1
    }
    
    
    
    // Scrolls the period buttons to the left to show period-status data for previous day.
    @IBAction func tomorrowButtonPressed(_ sender: Any) {
        
            // disable the 'yesterday' button momentarily to stop multiple repeat presses
        tomorrowButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.tomorrowButton.isEnabled = true })
        
            // disable the 'tomorrow' button if scrolling forward has reached the current day (Scrolling forward not allowed to future dates)
        if dateOffset < 0 {
            if dateOffset == -1 {
                tomorrowDay.disable()
                tomorrowDate.disable()
                tomorrowArrow.disable()
                tomorrowDay.flash(to: Constants.GRAY)
                tomorrowDate.flash(to: Constants.GRAY)
            } else {
                tomorrowDay.flash(to: Constants.BLUE)
                tomorrowDate.flash(to: Constants.BLUE)
            }
            
                // update 'dateOffset' flag - to reflect number of days into the past that the view should display, and update the subtitle's date labels accordingly
            dateOffset += 1
            refreshDateLabels()
            
                // update status labels for next set of period buttons due to be updated, and then animate: current set off-screen, due set on-screen
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
            
                // invert flag for next set of periods buttons to be updated
            loadPeriodsForSet1 = !loadPeriodsForSet1
        }
    }
    
    
    // Triggers segue to RAG assessment VC to allow user to enter RAG assessments for the selected period
    @IBAction func periodButtonPressed(_ sender: PeriodButton) {
        
            // record the user's selection
        var selectedPeriod: String!

        switch sender.tag {
        case 1:
            selectedPeriod = Constants.SCHOOL_DAY_PERIODS.p1
        case 2:
            selectedPeriod = Constants.SCHOOL_DAY_PERIODS.p2
        case 3:
            selectedPeriod = Constants.SCHOOL_DAY_PERIODS.p3
        case 4:
            selectedPeriod = Constants.SCHOOL_DAY_PERIODS.p4
        case 5:
            selectedPeriod = Constants.SCHOOL_DAY_PERIODS.p5
        case 6:
            selectedPeriod = Constants.SCHOOL_DAY_PERIODS.p6
        case 7:
            selectedPeriod = Constants.SCHOOL_DAY_PERIODS.p7
        default: break
        }
        
        var periodRAGAssessments = [RAGAssessment]()
        switch dateOffset {
        case 0:
            switch selectedPeriod {
            case Constants.SCHOOL_DAY_PERIODS.p1:
                periodRAGAssessments = day1RAGs[0].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p2:
                periodRAGAssessments = day1RAGs[1].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p3:
                periodRAGAssessments = day1RAGs[2].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p4:
                periodRAGAssessments = day1RAGs[3].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p5:
                periodRAGAssessments = day1RAGs[4].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p6:
                periodRAGAssessments = day1RAGs[5].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p7:
                periodRAGAssessments = day1RAGs[6].rAGAssessments
            default: break
            }
        case -1:
            switch selectedPeriod {
            case Constants.SCHOOL_DAY_PERIODS.p1:
                periodRAGAssessments = day2RAGs[0].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p2:
                periodRAGAssessments = day2RAGs[1].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p3:
                periodRAGAssessments = day2RAGs[2].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p4:
                periodRAGAssessments = day2RAGs[3].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p5:
                periodRAGAssessments = day2RAGs[4].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p6:
                periodRAGAssessments = day2RAGs[5].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p7:
                periodRAGAssessments = day2RAGs[6].rAGAssessments
            default: break
            }
        case -2:
            switch selectedPeriod {
            case Constants.SCHOOL_DAY_PERIODS.p1:
                periodRAGAssessments = day3RAGs[0].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p2:
                periodRAGAssessments = day3RAGs[1].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p3:
                periodRAGAssessments = day3RAGs[2].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p4:
                periodRAGAssessments = day3RAGs[3].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p5:
                periodRAGAssessments = day3RAGs[4].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p6:
                periodRAGAssessments = day3RAGs[5].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p7:
                periodRAGAssessments = day3RAGs[6].rAGAssessments
            default: break
            }
        case -3:
            switch selectedPeriod {
            case Constants.SCHOOL_DAY_PERIODS.p1:
                periodRAGAssessments = day4RAGs[0].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p2:
                periodRAGAssessments = day4RAGs[1].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p3:
                periodRAGAssessments = day4RAGs[2].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p4:
                periodRAGAssessments = day4RAGs[3].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p5:
                periodRAGAssessments = day4RAGs[4].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p6:
                periodRAGAssessments = day4RAGs[5].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p7:
                periodRAGAssessments = day4RAGs[6].rAGAssessments
            default: break
            }
        case -4:
            switch selectedPeriod {
            case Constants.SCHOOL_DAY_PERIODS.p1:
                periodRAGAssessments = day5RAGs[0].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p2:
                periodRAGAssessments = day5RAGs[1].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p3:
                periodRAGAssessments = day5RAGs[2].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p4:
                periodRAGAssessments = day5RAGs[3].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p5:
                periodRAGAssessments = day5RAGs[4].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p6:
                periodRAGAssessments = day5RAGs[5].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p7:
                periodRAGAssessments = day5RAGs[6].rAGAssessments
            default: break
            }
        case -5:
            switch selectedPeriod {
            case Constants.SCHOOL_DAY_PERIODS.p1:
                periodRAGAssessments = day6RAGs[0].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p2:
                periodRAGAssessments = day6RAGs[1].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p3:
                periodRAGAssessments = day6RAGs[2].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p4:
                periodRAGAssessments = day6RAGs[3].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p5:
                periodRAGAssessments = day6RAGs[4].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p6:
                periodRAGAssessments = day6RAGs[5].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p7:
                periodRAGAssessments = day6RAGs[6].rAGAssessments
            default: break
            }
        case -6:
            switch selectedPeriod {
            case Constants.SCHOOL_DAY_PERIODS.p1:
                periodRAGAssessments = day7RAGs[0].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p2:
                periodRAGAssessments = day7RAGs[1].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p3:
                periodRAGAssessments = day7RAGs[2].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p4:
                periodRAGAssessments = day7RAGs[3].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p5:
                periodRAGAssessments = day7RAGs[4].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p6:
                periodRAGAssessments = day7RAGs[5].rAGAssessments
            case Constants.SCHOOL_DAY_PERIODS.p7:
                periodRAGAssessments = day7RAGs[6].rAGAssessments
            default: break
            }
        default: break
        }
        
            // segue to RAG assessments VC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let RAGAssessmentsVC = storyboard.instantiateViewController(withIdentifier: "RAGAssessmentsVC") as! RAGAssessmentsVC
        RAGAssessmentsVC.dateOffset = self.dateOffset
        RAGAssessmentsVC.selectedPeriod = selectedPeriod
        RAGAssessmentsVC.periodRAGAssessments = periodRAGAssessments
        RAGAssessmentsVC.students = classStudents
        RAGAssessmentsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(RAGAssessmentsVC, animated: true)
    }
    
    
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
            let notifsCenter = UNUserNotificationCenter.current()
            notifsCenter.removeAllPendingNotificationRequests()
            
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_ID)
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_NAME)
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_SECURITY_LEVEL)
            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_CLASS_ID)
            self.performSegue(withIdentifier: "unwindRAGVCToLoginVCSegue", sender: self)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }

    
    
    // Updates the subtitle's date labels according to the currently set dateOffset (number of days into the past)
    func refreshDateLabels() {
        
            // update labels' day names
        todayDay.text = DataService.getDayString(for: dateOffset)
        yesterdayDay.text = DataService.getDayString(for: dateOffset - 1)
        tomorrowDay.text = DataService.getDayString(for: dateOffset + 1)
        
            // update labels' short dates
        todayDate.text = DataService.getDateString(for: dateOffset)
        yesterdayDate.text = DataService.getDateString(for: dateOffset - 1)
        tomorrowDate.text = DataService.getDateString(for: dateOffset + 1)
    }

    
    // Updates the statuses for a given set of Period Buttons - to reflect whether or not the RAG assessment has been completed yet for that period on the day indicated by the currently set dateOffset value. If a particular period has been completed, it is marked as such. If the current time is after a particular period's expected completion time, it is marked as 'Not Complete'. All others are left blank.
    func updateStatus(for set: [PeriodButtonStatusLabel]) {
        
        // clear status labels before setting
        for label in set {
            label.clearStatusLabel()
        }
            // get current Date
        let now = Date()
        
            // check status of school-day periods
        switch dateOffset {
        case 0:
            if now > now.dateAt(hours: Constants.P1_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P1_END_MINS) {
                set[0].setStatusNotComplete()
            }
            if now > now.dateAt(hours: Constants.P2_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P2_END_MINS) {
                set[1].setStatusNotComplete()
            }
            if now > now.dateAt(hours: Constants.P3_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P3_END_MINS) {
                set[2].setStatusNotComplete()
            }
            if now > now.dateAt(hours: Constants.P4_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P4_END_MINS) {
                set[3].setStatusNotComplete()
            }
            if now > now.dateAt(hours: Constants.P5_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P5_END_MINS) {
                set[4].setStatusNotComplete()
            }
            if now > now.dateAt(hours: Constants.P6_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P6_END_MINS) {
                set[5].setStatusNotComplete()
            }
            if now > now.dateAt(hours: Constants.P7_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P7_END_MINS) {
                set[6].setStatusNotComplete()
            }
            
            for period in day1RAGs {
                switch period.period {
                case Constants.SCHOOL_DAY_PERIODS.p1 :
                    if !period.rAGAssessments.isEmpty {
                        set[0].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p2:
                    if !period.rAGAssessments.isEmpty {
                        set[1].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p3:
                    if !period.rAGAssessments.isEmpty {
                        set[2].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p4:
                    if !period.rAGAssessments.isEmpty {
                        set[3].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p5:
                    if !period.rAGAssessments.isEmpty {
                        set[4].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p6:
                    if !period.rAGAssessments.isEmpty {
                        set[5].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p7:
                    if !period.rAGAssessments.isEmpty {
                        set[6].setStatusComplete()
                    }
                default: break
                }
            }
        case -1:
            for button in set {
                button.setStatusNotComplete()
            }
            for period in day2RAGs {
                switch period.period {
                case Constants.SCHOOL_DAY_PERIODS.p1 :
                    if !period.rAGAssessments.isEmpty {
                        set[0].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p2:
                    if !period.rAGAssessments.isEmpty {
                        set[1].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p3:
                    if !period.rAGAssessments.isEmpty {
                        set[2].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p4:
                    if !period.rAGAssessments.isEmpty {
                        set[3].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p5:
                    if !period.rAGAssessments.isEmpty {
                        set[4].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p6:
                    if !period.rAGAssessments.isEmpty {
                        set[5].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p7:
                    if !period.rAGAssessments.isEmpty {
                        set[6].setStatusComplete()
                    }
                default: break
                }
            }
        case -2:
            for button in set {
                button.setStatusNotComplete()
            }
            for period in day3RAGs {
                switch period.period {
                case Constants.SCHOOL_DAY_PERIODS.p1 :
                    if !period.rAGAssessments.isEmpty {
                        set[0].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p2:
                    if !period.rAGAssessments.isEmpty {
                        set[1].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p3:
                    if !period.rAGAssessments.isEmpty {
                        set[2].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p4:
                    if !period.rAGAssessments.isEmpty {
                        set[3].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p5:
                    if !period.rAGAssessments.isEmpty {
                        set[4].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p6:
                    if !period.rAGAssessments.isEmpty {
                        set[5].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p7:
                    if !period.rAGAssessments.isEmpty {
                        set[6].setStatusComplete()
                    }
                default: break
                }
            }
        case -3:
            for button in set {
                button.setStatusNotComplete()
            }
            for period in day4RAGs {
                switch period.period {
                case Constants.SCHOOL_DAY_PERIODS.p1 :
                    if !period.rAGAssessments.isEmpty {
                        set[0].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p2:
                    if !period.rAGAssessments.isEmpty {
                        set[1].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p3:
                    if !period.rAGAssessments.isEmpty {
                        set[2].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p4:
                    if !period.rAGAssessments.isEmpty {
                        set[3].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p5:
                    if !period.rAGAssessments.isEmpty {
                        set[4].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p6:
                    if !period.rAGAssessments.isEmpty {
                        set[5].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p7:
                    if !period.rAGAssessments.isEmpty {
                        set[6].setStatusComplete()
                    }
                default: break
                }
            }
        case -4:
            for button in set {
                button.setStatusNotComplete()
            }
            for period in day5RAGs {
                switch period.period {
                case Constants.SCHOOL_DAY_PERIODS.p1 :
                    if !period.rAGAssessments.isEmpty {
                        set[0].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p2:
                    if !period.rAGAssessments.isEmpty {
                        set[1].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p3:
                    if !period.rAGAssessments.isEmpty {
                        set[2].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p4:
                    if !period.rAGAssessments.isEmpty {
                        set[3].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p5:
                    if !period.rAGAssessments.isEmpty {
                        set[4].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p6:
                    if !period.rAGAssessments.isEmpty {
                        set[5].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p7:
                    if !period.rAGAssessments.isEmpty {
                        set[6].setStatusComplete()
                    }
                default: break
                }
            }
        case -5:
            for button in set {
                button.setStatusNotComplete()
            }
            for period in day6RAGs {
                switch period.period {
                case Constants.SCHOOL_DAY_PERIODS.p1 :
                    if !period.rAGAssessments.isEmpty {
                        set[0].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p2:
                    if !period.rAGAssessments.isEmpty {
                        set[1].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p3:
                    if !period.rAGAssessments.isEmpty {
                        set[2].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p4:
                    if !period.rAGAssessments.isEmpty {
                        set[3].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p5:
                    if !period.rAGAssessments.isEmpty {
                        set[4].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p6:
                    if !period.rAGAssessments.isEmpty {
                        set[5].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p7:
                    if !period.rAGAssessments.isEmpty {
                        set[6].setStatusComplete()
                    }
                default: break
                }
            }
        case -6:
            for button in set {
                button.setStatusNotComplete()
            }
            for period in day7RAGs {
                switch period.period {
                case Constants.SCHOOL_DAY_PERIODS.p1 :
                    if !period.rAGAssessments.isEmpty {
                        set[0].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p2:
                    if !period.rAGAssessments.isEmpty {
                        set[1].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p3:
                    if !period.rAGAssessments.isEmpty {
                        set[2].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p4:
                    if !period.rAGAssessments.isEmpty {
                        set[3].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p5:
                    if !period.rAGAssessments.isEmpty {
                        set[4].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p6:
                    if !period.rAGAssessments.isEmpty {
                        set[5].setStatusComplete()
                    }
                case Constants.SCHOOL_DAY_PERIODS.p7:
                    if !period.rAGAssessments.isEmpty {
                        set[6].setStatusComplete()
                    }
                default: break
                }
            }
        default:
            break
        }
    }
    
    func finishedFetching(classesWithStudents: [(schoolClass: SchoolClass, students: [Student])]) {
        // needed to conform to protocol - no implementation needed in this class
    }

    
}
