//
//  LoginVC.swift
//  BSA_v0.0
//
//  Created by Pete Holdsworth on 12/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit
import UserNotifications

class LoginVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UserAccountFetchingDelegate {
    

    // UI handles:
    @IBOutlet weak var titleBar: MaterialObject!
    @IBOutlet weak var titleBarTitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var subtitleXAlign: NSLayoutConstraint!
    @IBOutlet weak var usernameButton: UsernameButton!
    @IBOutlet weak var usernameButtonXAlign: NSLayoutConstraint!
    @IBOutlet weak var loginButtonXAlign: NSLayoutConstraint!
    @IBOutlet weak var loginButton: LoginButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var accountTableXAlign: NSLayoutConstraint!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordTextFieldXAlign: NSLayoutConstraint!
    
    
    // Properties:
    var loginAnimation: AnimationEngine?
    var selectAccountAnimation: AnimationEngine?
    var allAccounts = [UserAccount]()
    var selectedAccount: UserAccount?
    
    var dataService: DataService?
    
    var connectionTimer: Timer!
    
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // set VC color and title
        view.layer.backgroundColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0).cgColor
        titleBar.layer.backgroundColor = Constants.BLUE.cgColor
        titleBarTitle.text = "Behaviour Support App"
        titleBarTitle.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        titleBarTitle.textColor = .white
        navigationItem.title = "Behaviour Support App"
        subtitle.text = "Please Log In"
        
            // configure table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
            // initialise animation engines for sub-screens and set initial positions
        loginAnimation = AnimationEngine(layoutConstraints: [usernameButtonXAlign, passwordTextFieldXAlign, loginButtonXAlign])
        selectAccountAnimation = AnimationEngine(layoutConstraints: [accountTableXAlign])
        selectAccountAnimation?.setOffScreenRight()
        loginButton.isHidden = true
    
            // initiate DataService and request User Accounts from storage
        dataService = DataService()
        dataService?.userAccountFetchingDelegate = self
        dataService?.getAllUserAccounts()
        
            // add swipe-gesture recognisers to main view
        addGestureRecognisers()
        
        // add timer for connection time-out
        connectionTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(showConnectionTimeOutAlert), userInfo: nil, repeats: false)
        
    }
    
    @objc func showConnectionTimeOutAlert() {
        let alert = UIAlertController(title: "Network Error", message: "Please check your network connection", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//            self.connectionTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.showConnectionTimeOutAlert), userInfo: nil, repeats: false)
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Adds left / right swipe-gesture recognisers to the main view
    func addGestureRecognisers() {
        
            // add left-swipe recogniser
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(processGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
            // add right-swipe recogniser
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(processGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    // Processes recognised left/right swipe recognisers
    @objc func processGesture(gesture: UIGestureRecognizer) {
        if let gesture = gesture as? UISwipeGestureRecognizer {
            switch gesture.direction {
                
                // triggers navigation back to login screen (which first checks to make sure selection has been made)
            case UISwipeGestureRecognizerDirection.right:
                returnToLoginScreen()
                
                // navigates to account-selection screen
            case UISwipeGestureRecognizerDirection.left:
                setScreenAlignment(to: "selectAccount")
            default:
                break
            }
        }
    }
    
    
    // Requests all user accounts from storage every time view appears
    override func viewWillAppear(_ animated: Bool) {
        dataService?.getAllUserAccounts()
    }
    
    // Assigns fetched user accounts to class-level scope and reloads table
    func finishedFetching(userAccounts: [UserAccount]) {
        connectionTimer.invalidate()
        allAccounts = userAccounts
        tableView.reloadData()
    }
    
    
    // Animates screen to show account-selection table when username button is pressed
    @IBAction func usernameButtonTapped(_ sender: Any) {
        setScreenAlignment(to: "selectAccount")
    }

    // Triggers navigation back to login screen (which first checks to make sure selection has been made)
    @IBAction func accountButtonTapped(_ sender: Any) {
        returnToLoginScreen()
    }
    
    // Updates the username button's title to reflect the selection before animating the view back to the 'login' screen (First checks to make sure an account has been selected)
    func returnToLoginScreen() {
        if selectedAccount == nil {
            let alert = UIAlertController(title: "No Selection", message: "Please select an account to log into", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            usernameButton.setTitle(selectedAccount?.accountName, for: .normal)
            usernameButton.setTitleColor(UIColor(red: 94/255, green: 94/255, blue: 94/255, alpha: 1.0), for: .normal)
            loginButton.isHidden = false
            setScreenAlignment(to: "login")
        }
    }

    // Segue to appropriate tab-bar controller - according to the account selected
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard selectedAccount != nil else { return }
        
        guard selectedAccount?.password == passwordTextField.text else {
            let alert = UIAlertController(title: "Incorrect Password", message: "Please enter the correct password for the selected account", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
            // record account details
        UserDefaults.standard.set(selectedAccount?.id, forKey: Constants.LOGGED_IN_ACCOUNT_ID)
        UserDefaults.standard.set(selectedAccount?.accountName, forKey: Constants.LOGGED_IN_ACCOUNT_NAME)
        UserDefaults.standard.set(selectedAccount?.securityLevel, forKey: Constants.LOGGED_IN_ACCOUNT_SECURITY_LEVEL)
        UserDefaults.standard.set(selectedAccount?.schoolClassId, forKey: Constants.LOGGED_IN_ACCOUNT_CLASS_ID)
        
        switch selectedAccount!.accountName {
            case "Admin" :
                // go to Admin Tab Bar Controller)
                performSegue(withIdentifier: "showAdminAccountTabBarVC", sender: nil)
            default :
                
                // set notification reminders
            addRAGAssessmentReminders()
            
            // go to Class Tab Bar Controller
            performSegue(withIdentifier: "showClassAccountTabBarVC", sender: nil)
        }
        
    }
    
    // Sets notification reminders for logged-in class-user to complete RAG assessments on time
    func addRAGAssessmentReminders() {
        let notifsCenter = UNUserNotificationCenter.current()

            // period 1 reminder notification
        let p1Reminder = UNMutableNotificationContent()
        p1Reminder.title = "Period 1 RAG Assessment"
        p1Reminder.body = "Remember to complete the RAG Assessment for Period 1!"
        p1Reminder.sound = UNNotificationSound.default()
        
        let p1Date = Date().dateAt(hours: Constants.P1_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P1_END_MINS)
        let p1TriggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: p1Date)
        let p1Trigger = UNCalendarNotificationTrigger(dateMatching: p1TriggerDate, repeats: true)
        
        let p1Identifier = "p1LocalNotification"
        let p1Request = UNNotificationRequest(identifier: p1Identifier, content: p1Reminder, trigger: p1Trigger)
        notifsCenter.add(p1Request, withCompletionHandler: { (error) in
            if let error = error {
                print (error)
                // Something went wrong
            }
        })
        
            // period 2 reminder notification
        let p2Reminder = UNMutableNotificationContent()
        p2Reminder.title = "Period 2 RAG Assessment"
        p2Reminder.body = "Remember to complete the RAG Assessment for Period 2!"
        p2Reminder.sound = UNNotificationSound.default()
        
        let p2Date = Date().dateAt(hours: Constants.P2_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P2_END_MINS)
        let p2TriggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: p2Date)
        let p2Trigger = UNCalendarNotificationTrigger(dateMatching: p2TriggerDate, repeats: true)
        
        let p2Identifier = "p2LocalNotification"
        let p2Request = UNNotificationRequest(identifier: p2Identifier, content: p2Reminder, trigger: p2Trigger)
        notifsCenter.add(p2Request, withCompletionHandler: { (error) in
            if let error = error {
                print (error)
                // Something went wrong
            }
        })
        
            // period 3 reminder notification
        let p3Reminder = UNMutableNotificationContent()
        p3Reminder.title = "Period 3 RAG Assessment"
        p3Reminder.body = "Remember to complete the RAG Assessment for Period 3!"
        p3Reminder.sound = UNNotificationSound.default()
        
        let p3Date = Date().dateAt(hours: Constants.P3_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P3_END_MINS)
        let p3TriggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: p3Date)
        let p3Trigger = UNCalendarNotificationTrigger(dateMatching: p3TriggerDate, repeats: true)
        
        let p3Identifier = "p3LocalNotification"
        let p3Request = UNNotificationRequest(identifier: p3Identifier, content: p3Reminder, trigger: p3Trigger)
        notifsCenter.add(p3Request, withCompletionHandler: { (error) in
            if let error = error {
                print (error)
                // Something went wrong
            }
        })
        
            // period 4 reminder notification
        let p4Reminder = UNMutableNotificationContent()
        p4Reminder.title = "Period 4 RAG Assessment"
        p4Reminder.body = "Remember to complete the RAG Assessment for Period 4!"
        p4Reminder.sound = UNNotificationSound.default()
        
        let p4Date = Date().dateAt(hours: Constants.P4_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P4_END_MINS)
        let p4TriggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: p4Date)
        let p4Trigger = UNCalendarNotificationTrigger(dateMatching: p4TriggerDate, repeats: true)
        
        let p4Identifier = "p4LocalNotification"
        let p4Request = UNNotificationRequest(identifier: p4Identifier, content: p4Reminder, trigger: p4Trigger)
        notifsCenter.add(p4Request, withCompletionHandler: { (error) in
            if let error = error {
                print (error)
                // Something went wrong
            }
        })
        
        
            // period 5 reminder notification
        let p5Reminder = UNMutableNotificationContent()
        p5Reminder.title = "Period 5 RAG Assessment"
        p5Reminder.body = "Remember to complete the RAG Assessment for Period 5!"
        p5Reminder.sound = UNNotificationSound.default()
        
        let p5Date = Date().dateAt(hours: Constants.P5_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P5_END_MINS)
        let p5TriggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: p5Date)
        let p5Trigger = UNCalendarNotificationTrigger(dateMatching: p5TriggerDate, repeats: true)
        
        let p5Identifier = "p5LocalNotification"
        let p5Request = UNNotificationRequest(identifier: p5Identifier, content: p5Reminder, trigger: p5Trigger)
        notifsCenter.add(p5Request, withCompletionHandler: { (error) in
            if let error = error {
                print (error)
                // Something went wrong
            }
        })
        
            // period 6 reminder notification
        let p6Reminder = UNMutableNotificationContent()
        p6Reminder.title = "Period 6 RAG Assessment"
        p6Reminder.body = "Remember to complete the RAG Assessment for Period 6!"
        p6Reminder.sound = UNNotificationSound.default()
        
        let p6Date = Date().dateAt(hours: Constants.P6_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P6_END_MINS)
        let p6TriggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: p6Date)
        let p6Trigger = UNCalendarNotificationTrigger(dateMatching: p6TriggerDate, repeats: true)
        
        let p6Identifier = "p6LocalNotification"
        let p6Request = UNNotificationRequest(identifier: p6Identifier, content: p6Reminder, trigger: p6Trigger)
        notifsCenter.add(p6Request, withCompletionHandler: { (error) in
            if let error = error {
                print (error)
                // Something went wrong
            }
        })
        
            // period 7 reminder notification
        let p7Reminder = UNMutableNotificationContent()
        p7Reminder.title = "Period 7 RAG Assessment"
        p7Reminder.body = "Remember to complete the RAG Assessment for Period 7!"
        p7Reminder.sound = UNNotificationSound.default()
        
        let p7Date = Date().dateAt(hours: Constants.P7_END_HOURS + Constants.LATE_COMPLETION_HOURS, minutes: Constants.P7_END_MINS)
        let p7TriggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: p7Date)
        let p7Trigger = UNCalendarNotificationTrigger(dateMatching: p7TriggerDate, repeats: true)
        
        let p7Identifier = "p7LocalNotification"
        let p7Request = UNNotificationRequest(identifier: p7Identifier, content: p7Reminder, trigger: p7Trigger)
        notifsCenter.add(p7Request, withCompletionHandler: { (error) in
            if let error = error {
                print (error)
                // Something went wrong
            }
        })
        
    }


    // Sets number of rows in the table of account names
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allAccounts.isEmpty {
            return 0
        } else {
            return allAccounts.count + 2
        }
    }
    
    
    // Configures the cells in the table of account names
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // transparent cell used as padding at the top of the table
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTopPaddingCell", for: indexPath) as! TransparentCell
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
            
            // transparent cell containing the 'Login' button as the last row in the table
        } else if indexPath.row == allAccounts.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountLoginButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
            // configure 'Account Cell' for all other cells
        } else {
            let account = allAccounts[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
            cell.nameLabel.text = account.accountName
            if selectedAccount == nil {
                cell.backgroundColor = UIColor.white
                cell.accessoryType = .none
            } else if selectedAccount == account {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
    }
    
    // Sets the height for cells in table
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 20
        } else if indexPath.row == allAccounts.count + 1 {
            return 125
        } else {
            return 60
        }
    }
    
    // Updates the account-selection property according to a selected Account Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // guard against selection of the top-padding or bottom 'Login' button cells
        guard indexPath.row != 0 && indexPath.row != allAccounts.count + 1 else { return }
        
            // update account-selection
        let account = allAccounts[indexPath.row - 1]
        
        if selectedAccount == account {
            selectedAccount = nil
        } else {
            selectedAccount = account
        }

        tableView.reloadData()
    }


    // Animates the sub-screen views to simulate 2 separate view containers sliding left and right
    func setScreenAlignment(to screen: String) {
        switch screen {
            // animate view to the left - to show 'Login' container (username button and login button)
        case "login" :
            subtitle.text = "Please Log In"
            AnimationEngine.animate(constraint: subtitleXAlign, by: 200)
            loginAnimation?.animateOnFromScreenLeft()
            selectAccountAnimation?.animateOffScreenRight()
            
            // animate view to the right - to show 'Account' container (table of account names)
        case "selectAccount" :
            subtitle.text = "Select Account"
            AnimationEngine.animate(constraint: subtitleXAlign, by: -200)
            loginAnimation?.animateOffScreenLeft()
            selectAccountAnimation?.animateOnFromScreenRight()
        default :
            print ("unknown screen-alignment requested")
        }
    }
    
    // Allow child VC's to unwind to the login screen when the user logs out
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        // no preparation yet needed when the user logs out
    }

}

