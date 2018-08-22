//
//  IncidentsVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit
import UserNotifications

class IncidentsVC: UIViewController {

    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // set VC color and title, and add logout button
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Incidents"
        addLogoutButton()
    }

    // Triggers segue to VC with a new Incident Form for the user to complete
    @IBAction func newIncidentButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let incidentFormVC = storyboard.instantiateViewController(withIdentifier: "incidentFormVC") as! IncidentFormVC
        incidentFormVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(incidentFormVC, animated: true)
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
            self.performSegue(withIdentifier: "unwindIncidentsVCToLoginVCSegue", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
