//
//  LoginVC.swift
//  BSA_v0.0
//
//  Created by Pete Holdsworth on 12/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

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
    

    // Properties:
    var loginAnimation: AnimationEngine?
    var selectAccountAnimation: AnimationEngine?
    var allAccounts = [UserAccount]()
    var selectedAccount: UserAccount?
    
    var dataService: DataService?
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // set VC color and title
        view.layer.backgroundColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0).cgColor
        titleBar.layer.backgroundColor = Constants.BLUE.cgColor
        titleBarTitle.text = "Behaviour Support - CRP"
        titleBarTitle.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        titleBarTitle.textColor = .white
        navigationItem.title = "Behaviour Support - CRP"
        subtitle.text = "Please Log In"
        
            // configure table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
        dataService = DataService()
        dataService?.userAccountFetchingDelegate = self
        dataService?.getAllUserAccounts()
        
            // initialise animation engines for sub-screens and set initial positions
        loginAnimation = AnimationEngine(layoutConstraints: [usernameButtonXAlign, loginButtonXAlign])
        selectAccountAnimation = AnimationEngine(layoutConstraints: [accountTableXAlign])
        selectAccountAnimation?.setOffScreenRight()
        loginButton.isHidden = true
    
            // retrieve account names and display in table
//        if let accounts = Data.getAllUserAccounts() {
//            allAccounts = accounts
//            tableView.reloadData()
//        } else {
//            // problem getting data
//            print ("error getting user accounts data for Login vc")
//        }
        
        
        
    }
    
    
    func finishedFetching(userAccounts: [UserAccount]) {
        allAccounts = userAccounts
        tableView.reloadData()
    }
    
    
    // Animates screen to show account-selection table when username button is pressed
    @IBAction func usernameButtonTapped(_ sender: Any) {
        setScreenAlignment(to: "selectAccount")
    }

    // Updates the username button's title to reflect the selection before animating the view back to the 'login' screen (First checks to make sure an account has been selected)
    @IBAction func accountButtonTapped(_ sender: Any) {
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
            // go to Class Tab Bar Controller
            performSegue(withIdentifier: "showClassAccountTabBarVC", sender: nil)
        }
        
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


    // Allow child VC's to unwind to the login screen when the user logs out
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        // no preparation yet needed when the user logs out
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

}

