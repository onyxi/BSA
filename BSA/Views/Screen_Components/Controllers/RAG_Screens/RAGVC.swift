//
//  RAGVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 14/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class RAGVC: UIViewController, SchoolClassFetchingDelegate, StudentFetchingDelegate, RAGAssessmentsFetchingDelegate {
    
    
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
//    @IBOutlet weak var set1PeriodsWidth: NSLayoutConstraint!
    
    @IBOutlet weak var set2Period1Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period2Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period3Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period4Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period5Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period6Status: PeriodButtonStatusLabel!
    @IBOutlet weak var set2Period7Status: PeriodButtonStatusLabel!
    var periodSet2Statuses: [PeriodButtonStatusLabel]!
    
    @IBOutlet weak var set2PeriodsXAlign: NSLayoutConstraint!
//    @IBOutlet weak var set2PeriodsWidth: NSLayoutConstraint!
    
    @IBOutlet weak var yesterdayButton: SubtitleBarButton!
    @IBOutlet weak var tomorrowButton: SubtitleBarButton!
    
    
    // Properties:
    var set1PeriodsAnimation: AnimationEngine?
    var set2PeriodsAnimation: AnimationEngine?
    var dateOffset = 0
    var loadPeriodsForSet1 = true
//    var schoolClass: SchoolClass?
    var classStudents: [Student]?
//    var selectedPeriod: Int?
    var rAGAssessments: [RAGAssessment]?
    
    var dataService: DataService?
    
    var day1RAGs = [(period: SchoolDayPeriod, rAGAssessments: [RAGAssessment])]()
    var day2RAGs = [(period: SchoolDayPeriod, rAGAssessments: [RAGAssessment])]()
    var day3RAGs = [(period: SchoolDayPeriod, rAGAssessments: [RAGAssessment])]()
    var day4RAGs = [(period: SchoolDayPeriod, rAGAssessments: [RAGAssessment])]()
    var day5RAGs = [(period: SchoolDayPeriod, rAGAssessments: [RAGAssessment])]()
    var day6RAGs = [(period: SchoolDayPeriod, rAGAssessments: [RAGAssessment])]()
    var day7RAGs = [(period: SchoolDayPeriod, rAGAssessments: [RAGAssessment])]()
    
    
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
        
        
        dataService = DataService()
        dataService?.schoolClassFetchingDelegate = self
        dataService?.studentFetchingDelegate = self
        dataService?.rAGAssessmentsFetchingDelegate = self
        dataService?.getSchoolClass(withId: UserDefaults.standard.string(forKey: Constants.LOGGED_IN_ACCOUNT_CLASS_ID)!)
        
//        getClassStudents()
        setupRAGAssessmentArrays()
//        retrieveAndUnpackRAGAssessments()
       
    }

    func finishedFetching(schoolClasses: [SchoolClass]) {
        dataService?.getStudents(for: schoolClasses[0])
    }
    
    func finishedFetching(students: [Student]) {
        classStudents = students
        dataService?.getRAGAssessments(for: students, fromTimePeriod: .allTime)
    }
    
    func finishedFetching(rAGAssessments: [RAGAssessment]) {
        self.rAGAssessments = rAGAssessments
        retrieveAndUnpackRAGAssessments()
    }
    
    
    
    func finishedFetching(classesWithStudents: [(schoolClass: SchoolClass, students: [Student])]) {
        // no implementation needed in this class
    }
    
//    func getClassStudents() {
//
//        if let schoolClass = Data.getSchoolClass(numbered: UserDefaults.standard.integer(forKey: Constants.LOGGED_IN_ACCOUNT_NUMBER_KEY)) {
//                classStudents = Data.getStudents(for: schoolClass)
//        }
//    }


    
    
    
    func setupRAGAssessmentArrays() {
        day1RAGs = [
            (period: .p1, rAGAssessments: [RAGAssessment]()),
            (period: .p2, rAGAssessments: [RAGAssessment]()),
            (period: .p3, rAGAssessments: [RAGAssessment]()),
            (period: .p4, rAGAssessments: [RAGAssessment]()),
            (period: .p5, rAGAssessments: [RAGAssessment]()),
            (period: .p6, rAGAssessments: [RAGAssessment]()),
            (period: .p7, rAGAssessments: [RAGAssessment]())]
        day2RAGs = [
            (period: .p1, rAGAssessments: [RAGAssessment]()),
            (period: .p2, rAGAssessments: [RAGAssessment]()),
            (period: .p3, rAGAssessments: [RAGAssessment]()),
            (period: .p4, rAGAssessments: [RAGAssessment]()),
            (period: .p5, rAGAssessments: [RAGAssessment]()),
            (period: .p6, rAGAssessments: [RAGAssessment]()),
            (period: .p7, rAGAssessments: [RAGAssessment]())]
        day3RAGs = [
            (period: .p1, rAGAssessments: [RAGAssessment]()),
            (period: .p2, rAGAssessments: [RAGAssessment]()),
            (period: .p3, rAGAssessments: [RAGAssessment]()),
            (period: .p4, rAGAssessments: [RAGAssessment]()),
            (period: .p5, rAGAssessments: [RAGAssessment]()),
            (period: .p6, rAGAssessments: [RAGAssessment]()),
            (period: .p7, rAGAssessments: [RAGAssessment]())]
        day4RAGs = [
            (period: .p1, rAGAssessments: [RAGAssessment]()),
            (period: .p2, rAGAssessments: [RAGAssessment]()),
            (period: .p3, rAGAssessments: [RAGAssessment]()),
            (period: .p4, rAGAssessments: [RAGAssessment]()),
            (period: .p5, rAGAssessments: [RAGAssessment]()),
            (period: .p6, rAGAssessments: [RAGAssessment]()),
            (period: .p7, rAGAssessments: [RAGAssessment]())]
        day5RAGs = [
            (period: .p1, rAGAssessments: [RAGAssessment]()),
            (period: .p2, rAGAssessments: [RAGAssessment]()),
            (period: .p3, rAGAssessments: [RAGAssessment]()),
            (period: .p4, rAGAssessments: [RAGAssessment]()),
            (period: .p5, rAGAssessments: [RAGAssessment]()),
            (period: .p6, rAGAssessments: [RAGAssessment]()),
            (period: .p7, rAGAssessments: [RAGAssessment]())]
        day6RAGs = [
            (period: .p1, rAGAssessments: [RAGAssessment]()),
            (period: .p2, rAGAssessments: [RAGAssessment]()),
            (period: .p3, rAGAssessments: [RAGAssessment]()),
            (period: .p4, rAGAssessments: [RAGAssessment]()),
            (period: .p5, rAGAssessments: [RAGAssessment]()),
            (period: .p6, rAGAssessments: [RAGAssessment]()),
            (period: .p7, rAGAssessments: [RAGAssessment]())]
        day7RAGs = [
            (period: .p1, rAGAssessments: [RAGAssessment]()),
            (period: .p2, rAGAssessments: [RAGAssessment]()),
            (period: .p3, rAGAssessments: [RAGAssessment]()),
            (period: .p4, rAGAssessments: [RAGAssessment]()),
            (period: .p5, rAGAssessments: [RAGAssessment]()),
            (period: .p6, rAGAssessments: [RAGAssessment]()),
            (period: .p7, rAGAssessments: [RAGAssessment]())]
    }
    
    func retrieveAndUnpackRAGAssessments() {

//        guard classStudents != nil else {
//            // failed to get class students
//            print ("failed to get class students")
//            return
//        }
//
//        guard let rAGAssessments = Data.getRAGAssessments(for: classStudents!, fromTimePeriod: .allTime) else {
//            // failed to get RAG Assessments
//            print ("failed to get RAG Assessments")
//            return
//        }
        
        guard classStudents != nil else {
            // failed to get class students
            print ("failed to get class students")
            return
        }
        
        guard rAGAssessments != nil else {
            // failed to get RAG Assessments
            print ("failed to get RAG Assessments")
            return
        }
    
        
        
        for rag in rAGAssessments! {
            switch rag.date {
            case Date().withOffset(dateOffset: 0):
                switch rag.period {
                case .p1 :
                    day1RAGs[0].rAGAssessments.append(rag)
                case .p2:
                    day1RAGs[1].rAGAssessments.append(rag)
                case .p3:
                    day1RAGs[2].rAGAssessments.append(rag)
                case .p4:
                    day1RAGs[3].rAGAssessments.append(rag)
                case .p5:
                    day1RAGs[4].rAGAssessments.append(rag)
                case .p6:
                    day1RAGs[5].rAGAssessments.append(rag)
                case .p7:
                    day1RAGs[6].rAGAssessments.append(rag)
                default:
                    break
                }
            case Date().withOffset(dateOffset: -1):
                switch rag.period {
                case .p1 :
                    day2RAGs[0].rAGAssessments.append(rag)
                case .p2:
                    day2RAGs[1].rAGAssessments.append(rag)
                case .p3:
                    day2RAGs[2].rAGAssessments.append(rag)
                case .p4:
                    day2RAGs[3].rAGAssessments.append(rag)
                case .p5:
                    day2RAGs[4].rAGAssessments.append(rag)
                case .p6:
                    day2RAGs[5].rAGAssessments.append(rag)
                case .p7:
                    day2RAGs[6].rAGAssessments.append(rag)
                default:
                    break
                }
            case Date().withOffset(dateOffset: -2):
                switch rag.period {
                case .p1 :
                    day3RAGs[0].rAGAssessments.append(rag)
                case .p2:
                    day3RAGs[1].rAGAssessments.append(rag)
                case .p3:
                    day3RAGs[2].rAGAssessments.append(rag)
                case .p4:
                    day3RAGs[3].rAGAssessments.append(rag)
                case .p5:
                    day3RAGs[4].rAGAssessments.append(rag)
                case .p6:
                    day3RAGs[5].rAGAssessments.append(rag)
                case .p7:
                    day3RAGs[6].rAGAssessments.append(rag)
                default:
                    break
                }
            case Date().withOffset(dateOffset: -3):
                switch rag.period {
                case .p1 :
                    day4RAGs[0].rAGAssessments.append(rag)
                case .p2:
                    day4RAGs[1].rAGAssessments.append(rag)
                case .p3:
                    day4RAGs[2].rAGAssessments.append(rag)
                case .p4:
                    day4RAGs[3].rAGAssessments.append(rag)
                case .p5:
                    day4RAGs[4].rAGAssessments.append(rag)
                case .p6:
                    day4RAGs[5].rAGAssessments.append(rag)
                case .p7:
                    day4RAGs[6].rAGAssessments.append(rag)
                default:
                    break
                }
            case Date().withOffset(dateOffset: -4):
                switch rag.period {
                case .p1 :
                    day5RAGs[0].rAGAssessments.append(rag)
                case .p2:
                    day5RAGs[1].rAGAssessments.append(rag)
                case .p3:
                    day5RAGs[2].rAGAssessments.append(rag)
                case .p4:
                    day5RAGs[3].rAGAssessments.append(rag)
                case .p5:
                    day5RAGs[4].rAGAssessments.append(rag)
                case .p6:
                    day5RAGs[5].rAGAssessments.append(rag)
                case .p7:
                    day5RAGs[6].rAGAssessments.append(rag)
                default:
                    break
                }
            case Date().withOffset(dateOffset: -5):
                switch rag.period {
                case .p1 :
                    day6RAGs[0].rAGAssessments.append(rag)
                case .p2:
                    day6RAGs[1].rAGAssessments.append(rag)
                case .p3:
                    day6RAGs[2].rAGAssessments.append(rag)
                case .p4:
                    day6RAGs[3].rAGAssessments.append(rag)
                case .p5:
                    day6RAGs[4].rAGAssessments.append(rag)
                case .p6:
                    day6RAGs[5].rAGAssessments.append(rag)
                case .p7:
                    day6RAGs[6].rAGAssessments.append(rag)
                default:
                    break
                }
            case Date().withOffset(dateOffset: -6):
                switch rag.period {
                case .p1 :
                    day7RAGs[0].rAGAssessments.append(rag)
                case .p2:
                    day7RAGs[1].rAGAssessments.append(rag)
                case .p3:
                    day7RAGs[2].rAGAssessments.append(rag)
                case .p4:
                    day7RAGs[3].rAGAssessments.append(rag)
                case .p5:
                    day7RAGs[4].rAGAssessments.append(rag)
                case .p6:
                    day7RAGs[5].rAGAssessments.append(rag)
                case .p7:
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
        
            // check to make sure that desired period status data has been retrieved from storage
//        guard days != nil else { return }
//        guard dateOffset < (days?.count)! - 1 else { return }
        
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
        var selectedPeriod: SchoolDayPeriod!

        switch sender.tag {
        case 1:
            selectedPeriod = .p1
        case 2:
            selectedPeriod = .p2
        case 3:
            selectedPeriod = .p3
        case 4:
            selectedPeriod = .p4
        case 5:
            selectedPeriod = .p5
        case 6:
            selectedPeriod = .p6
        case 7:
            selectedPeriod = .p7
        default: break
        }
        
        var periodRAGAssessments = [RAGAssessment]()
        switch dateOffset {
        case 0:
            switch selectedPeriod {
            case .p1:
                periodRAGAssessments = day1RAGs[0].rAGAssessments
            case .p2:
                periodRAGAssessments = day1RAGs[1].rAGAssessments
            case .p3:
                periodRAGAssessments = day1RAGs[2].rAGAssessments
            case .p4:
                periodRAGAssessments = day1RAGs[3].rAGAssessments
            case .p5:
                periodRAGAssessments = day1RAGs[4].rAGAssessments
            case .p6:
                periodRAGAssessments = day1RAGs[5].rAGAssessments
            case .p7:
                periodRAGAssessments = day1RAGs[6].rAGAssessments
            default: break
            }
        case -1:
            switch selectedPeriod {
            case .p1:
                periodRAGAssessments = day2RAGs[0].rAGAssessments
            case .p2:
                periodRAGAssessments = day2RAGs[1].rAGAssessments
            case .p3:
                periodRAGAssessments = day2RAGs[2].rAGAssessments
            case .p4:
                periodRAGAssessments = day2RAGs[3].rAGAssessments
            case .p5:
                periodRAGAssessments = day2RAGs[4].rAGAssessments
            case .p6:
                periodRAGAssessments = day2RAGs[5].rAGAssessments
            case .p7:
                periodRAGAssessments = day2RAGs[6].rAGAssessments
            default: break
            }
        case -2:
            switch selectedPeriod {
            case .p1:
                periodRAGAssessments = day3RAGs[0].rAGAssessments
            case .p2:
                periodRAGAssessments = day3RAGs[1].rAGAssessments
            case .p3:
                periodRAGAssessments = day3RAGs[2].rAGAssessments
            case .p4:
                periodRAGAssessments = day3RAGs[3].rAGAssessments
            case .p5:
                periodRAGAssessments = day3RAGs[4].rAGAssessments
            case .p6:
                periodRAGAssessments = day3RAGs[5].rAGAssessments
            case .p7:
                periodRAGAssessments = day3RAGs[6].rAGAssessments
            default: break
            }
        case -3:
            switch selectedPeriod {
            case .p1:
                periodRAGAssessments = day4RAGs[0].rAGAssessments
            case .p2:
                periodRAGAssessments = day4RAGs[1].rAGAssessments
            case .p3:
                periodRAGAssessments = day4RAGs[2].rAGAssessments
            case .p4:
                periodRAGAssessments = day4RAGs[3].rAGAssessments
            case .p5:
                periodRAGAssessments = day4RAGs[4].rAGAssessments
            case .p6:
                periodRAGAssessments = day4RAGs[5].rAGAssessments
            case .p7:
                periodRAGAssessments = day4RAGs[6].rAGAssessments
            default: break
            }
        case -4:
            switch selectedPeriod {
            case .p1:
                periodRAGAssessments = day5RAGs[0].rAGAssessments
            case .p2:
                periodRAGAssessments = day5RAGs[1].rAGAssessments
            case .p3:
                periodRAGAssessments = day5RAGs[2].rAGAssessments
            case .p4:
                periodRAGAssessments = day5RAGs[3].rAGAssessments
            case .p5:
                periodRAGAssessments = day5RAGs[4].rAGAssessments
            case .p6:
                periodRAGAssessments = day5RAGs[5].rAGAssessments
            case .p7:
                periodRAGAssessments = day5RAGs[6].rAGAssessments
            default: break
            }
        case -5:
            switch selectedPeriod {
            case .p1:
                periodRAGAssessments = day6RAGs[0].rAGAssessments
            case .p2:
                periodRAGAssessments = day6RAGs[1].rAGAssessments
            case .p3:
                periodRAGAssessments = day6RAGs[2].rAGAssessments
            case .p4:
                periodRAGAssessments = day6RAGs[3].rAGAssessments
            case .p5:
                periodRAGAssessments = day6RAGs[4].rAGAssessments
            case .p6:
                periodRAGAssessments = day6RAGs[5].rAGAssessments
            case .p7:
                periodRAGAssessments = day6RAGs[6].rAGAssessments
            default: break
            }
        case -6:
            switch selectedPeriod {
            case .p1:
                periodRAGAssessments = day7RAGs[0].rAGAssessments
            case .p2:
                periodRAGAssessments = day7RAGs[1].rAGAssessments
            case .p3:
                periodRAGAssessments = day7RAGs[2].rAGAssessments
            case .p4:
                periodRAGAssessments = day7RAGs[3].rAGAssessments
            case .p5:
                periodRAGAssessments = day7RAGs[4].rAGAssessments
            case .p6:
                periodRAGAssessments = day7RAGs[5].rAGAssessments
            case .p7:
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
                // remove record of logged in account and segue to login screen
//            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_NUMBER_KEY)
            // remove record of logged in account and segue to login screen
            //            UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_ACCOUNT_NUMBER_KEY)
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
        
            // make sure data has been retreived from storage, and get current Date
//        guard days != nil else { return }
        let now = Date()
        
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
                case .p1 :
                    if !period.rAGAssessments.isEmpty {
                        set[0].setStatusComplete()
                    }
                case .p2:
                    if !period.rAGAssessments.isEmpty {
                        set[1].setStatusComplete()
                    }
                case .p3:
                    if !period.rAGAssessments.isEmpty {
                        set[2].setStatusComplete()
                    }
                case .p4:
                    if !period.rAGAssessments.isEmpty {
                        set[3].setStatusComplete()
                    }
                case .p5:
                    if !period.rAGAssessments.isEmpty {
                        set[4].setStatusComplete()
                    }
                case .p6:
                    if !period.rAGAssessments.isEmpty {
                        set[5].setStatusComplete()
                    }
                case .p7:
                    if !period.rAGAssessments.isEmpty {
                        set[6].setStatusComplete()
                    }
                }
            }
        case -1:
            for button in set {
                button.setStatusNotComplete()
            }
            for period in day2RAGs {
                switch period.period {
                case .p1 :
                    if !period.rAGAssessments.isEmpty {
                        set[0].setStatusComplete()
                    }
                case .p2:
                    if !period.rAGAssessments.isEmpty {
                        set[1].setStatusComplete()
                    }
                case .p3:
                    if !period.rAGAssessments.isEmpty {
                        set[2].setStatusComplete()
                    }
                case .p4:
                    if !period.rAGAssessments.isEmpty {
                        set[3].setStatusComplete()
                    }
                case .p5:
                    if !period.rAGAssessments.isEmpty {
                        set[4].setStatusComplete()
                    }
                case .p6:
                    if !period.rAGAssessments.isEmpty {
                        set[5].setStatusComplete()
                    }
                case .p7:
                    if !period.rAGAssessments.isEmpty {
                        set[6].setStatusComplete()
                    }
                }
            }
        case -2:
            for button in set {
                button.setStatusNotComplete()
            }
            for period in day3RAGs {
                switch period.period {
                case .p1 :
                    if !period.rAGAssessments.isEmpty {
                        set[0].setStatusComplete()
                    }
                case .p2:
                    if !period.rAGAssessments.isEmpty {
                        set[1].setStatusComplete()
                    }
                case .p3:
                    if !period.rAGAssessments.isEmpty {
                        set[2].setStatusComplete()
                    }
                case .p4:
                    if !period.rAGAssessments.isEmpty {
                        set[3].setStatusComplete()
                    }
                case .p5:
                    if !period.rAGAssessments.isEmpty {
                        set[4].setStatusComplete()
                    }
                case .p6:
                    if !period.rAGAssessments.isEmpty {
                        set[5].setStatusComplete()
                    }
                case .p7:
                    if !period.rAGAssessments.isEmpty {
                        set[6].setStatusComplete()
                    }
                }
            }
        case -3:
            for button in set {
                button.setStatusNotComplete()
            }
            for period in day4RAGs {
                switch period.period {
                case .p1 :
                    if !period.rAGAssessments.isEmpty {
                        set[0].setStatusComplete()
                    }
                case .p2:
                    if !period.rAGAssessments.isEmpty {
                        set[1].setStatusComplete()
                    }
                case .p3:
                    if !period.rAGAssessments.isEmpty {
                        set[2].setStatusComplete()
                    }
                case .p4:
                    if !period.rAGAssessments.isEmpty {
                        set[3].setStatusComplete()
                    }
                case .p5:
                    if !period.rAGAssessments.isEmpty {
                        set[4].setStatusComplete()
                    }
                case .p6:
                    if !period.rAGAssessments.isEmpty {
                        set[5].setStatusComplete()
                    }
                case .p7:
                    if !period.rAGAssessments.isEmpty {
                        set[6].setStatusComplete()
                    }
                }
            }
        case -4:
            for button in set {
                button.setStatusNotComplete()
            }
            for period in day5RAGs {
                switch period.period {
                case .p1 :
                    if !period.rAGAssessments.isEmpty {
                        set[0].setStatusComplete()
                    }
                case .p2:
                    if !period.rAGAssessments.isEmpty {
                        set[1].setStatusComplete()
                    }
                case .p3:
                    if !period.rAGAssessments.isEmpty {
                        set[2].setStatusComplete()
                    }
                case .p4:
                    if !period.rAGAssessments.isEmpty {
                        set[3].setStatusComplete()
                    }
                case .p5:
                    if !period.rAGAssessments.isEmpty {
                        set[4].setStatusComplete()
                    }
                case .p6:
                    if !period.rAGAssessments.isEmpty {
                        set[5].setStatusComplete()
                    }
                case .p7:
                    if !period.rAGAssessments.isEmpty {
                        set[6].setStatusComplete()
                    }
                }
            }
        case -5:
            for button in set {
                button.setStatusNotComplete()
            }
            for period in day6RAGs {
                switch period.period {
                case .p1 :
                    if !period.rAGAssessments.isEmpty {
                        set[0].setStatusComplete()
                    }
                case .p2:
                    if !period.rAGAssessments.isEmpty {
                        set[1].setStatusComplete()
                    }
                case .p3:
                    if !period.rAGAssessments.isEmpty {
                        set[2].setStatusComplete()
                    }
                case .p4:
                    if !period.rAGAssessments.isEmpty {
                        set[3].setStatusComplete()
                    }
                case .p5:
                    if !period.rAGAssessments.isEmpty {
                        set[4].setStatusComplete()
                    }
                case .p6:
                    if !period.rAGAssessments.isEmpty {
                        set[5].setStatusComplete()
                    }
                case .p7:
                    if !period.rAGAssessments.isEmpty {
                        set[6].setStatusComplete()
                    }
                }
            }
        case -6:
            for button in set {
                button.setStatusNotComplete()
            }
            for period in day7RAGs {
                switch period.period {
                case .p1 :
                    if !period.rAGAssessments.isEmpty {
                        set[0].setStatusComplete()
                    }
                case .p2:
                    if !period.rAGAssessments.isEmpty {
                        set[1].setStatusComplete()
                    }
                case .p3:
                    if !period.rAGAssessments.isEmpty {
                        set[2].setStatusComplete()
                    }
                case .p4:
                    if !period.rAGAssessments.isEmpty {
                        set[3].setStatusComplete()
                    }
                case .p5:
                    if !period.rAGAssessments.isEmpty {
                        set[4].setStatusComplete()
                    }
                case .p6:
                    if !period.rAGAssessments.isEmpty {
                        set[5].setStatusComplete()
                    }
                case .p7:
                    if !period.rAGAssessments.isEmpty {
                        set[6].setStatusComplete()
                    }
                }
            }
        default:
            break
        }
        
        
        
//            // Period Button 1
//        if days![-dateOffset].p1 == 1 {
//            set[0].setStatusComplete()
//        } else if dateOffset < 0 || now > now.dateAt(hours: Constants.P1_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P1_END_MINS) {
//            set[0].setStatusNotComplete()
//        }
//
//            // Period Button 2
//        if days![-dateOffset].p2 == 1 {
//            set[1].setStatusComplete()
//        } else if dateOffset < 0 || now > now.dateAt(hours: Constants.P2_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P2_END_MINS) {
//            set[1].setStatusNotComplete()
//        }
//
//            // Period Button 3
//        if days![-dateOffset].p3 == 1 {
//            set[2].setStatusComplete()
//        } else if dateOffset < 0 || now > now.dateAt(hours: Constants.P3_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P3_END_MINS) {
//            set[2].setStatusNotComplete()
//        }
//
//            // Period Button 4
//        if days![-dateOffset].p4 == 1 {
//            set[3].setStatusComplete()
//        } else if dateOffset < 0 || now > now.dateAt(hours: Constants.P4_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P4_END_MINS) {
//            set[3].setStatusNotComplete()
//        }
//
//            // Period Button 5
//        if days![-dateOffset].p5 == 1 {
//            set[4].setStatusComplete()
//        } else if dateOffset < 0 || now > now.dateAt(hours: Constants.P5_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P5_END_MINS) {
//            set[4].setStatusNotComplete()
//        }
//
//            // Period Button 6
//        if days![-dateOffset].p6 == 1 {
//            set[5].setStatusComplete()
//        } else if dateOffset < 0 || now > now.dateAt(hours: Constants.P6_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P6_END_MINS) {
//            set[5].setStatusNotComplete()
//        }
//
//            // Period Button 7
//        if days![-dateOffset].p7 == 1 {
//            set[6].setStatusComplete()
//        } else if dateOffset < 0 || now > now.dateAt(hours: Constants.P7_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P7_END_MINS) {
//            set[6].setStatusNotComplete()
//        }
    }
    
    
    
}
