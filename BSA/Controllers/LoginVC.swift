//
//  LoginVC.swift
//  BSA_v0.0
//
//  Created by Pete Holdsworth on 12/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    

    
    var loginAnimation: AnimationEngine?
    var selectAccountAnimation: AnimationEngine?
    
    var allAccounts = [UserAccount]()
    var selectedAccount: UserAccount?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
        view.layer.backgroundColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0).cgColor
        navigationItem.title = "Behaviour Support - CRP"
        subtitle.text = "Please Log In"
        
        loginAnimation = AnimationEngine(layoutConstraints: [usernameButtonXAlign, loginButtonXAlign])
        selectAccountAnimation = AnimationEngine(layoutConstraints: [accountTableXAlign])
        selectAccountAnimation?.setOffScreenRight()
        loginButton.isHidden = true
        
        titleBar.layer.backgroundColor = Constants.BLUE.cgColor
        titleBarTitle.text = "Behaviour Support - CRP"
        titleBarTitle.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        titleBarTitle.textColor = .white
        
        allAccounts = Data.getAccounts()
        tableView.reloadData()
    }
    
    @IBAction func usernameButtonTapped(_ sender: Any) {
        setScreenAlignment(to: "selectAccount")
    }

    
    @IBAction func accountButtonTapped(_ sender: Any) {
        
        if selectedAccount == nil {
            let alert = UIAlertController(title: "No Selection", message: "Please select an account to log into", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            usernameButton.setTitle(selectedAccount?.name, for: .normal)
            usernameButton.setTitleColor(UIColor(red: 94/255, green: 94/255, blue: 94/255, alpha: 1.0), for: .normal)
            loginButton.isHidden = false
            setScreenAlignment(to: "login")
        }
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard selectedAccount != nil else { return }
        
        switch selectedAccount!.name {
        case "Admin" :
            // go to Admin Tab Bar Controller
            let alert = UIAlertController(title: "Account Unavailable", message: "Admin account currently unavailable, please choose a class account", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            break
        default :
            // go to Class Tab Bar Controller
            performSegue(withIdentifier: "showClassAccountTabBarVC", sender: nil)
            break
        }
        
    }
    

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allAccounts == nil {
            return 0
        } else {
            return allAccounts.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTopPaddingCell", for: indexPath) as! TransparentCell
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.row == allAccounts.count + 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountLoginButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
        } else {
        
            let account = allAccounts[indexPath.row - 1]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
            cell.nameLabel.text = allAccounts[indexPath.row - 1].name
            
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
    
    // set height for cells in table
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 20
        } else if indexPath.row == allAccounts.count + 1 {
            return 125
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.row != 0 && indexPath.row != allAccounts.count + 1 else { return }
        
        let account = allAccounts[indexPath.row - 1]
        
        if selectedAccount == account {
            selectedAccount = nil
        } else {
            selectedAccount = account
        }

        tableView.reloadData()
    }


    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }

    func setScreenAlignment(to screen: String) {
        switch screen {
        case "login" :
            subtitle.text = "Please Log In"
            AnimationEngine.animate(constraint: subtitleXAlign, by: 200)
            loginAnimation?.animateOnFromScreenLeft()
            selectAccountAnimation?.animateOffScreenRight()
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

