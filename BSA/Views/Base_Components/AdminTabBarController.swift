//
//  AdminTabBarController.swift
//  BSA
//
//  Created by Pete Holdsworth on 11/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class AdminTabBarController: UITabBarController {

    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background color of tab bar
        self.tabBar.barTintColor = Constants.BLACK
        
        // get custom tab bar symbols from assets ('selected' symbols)
        let imagesForSelectedState = [
            UIImage(named: "tabBarPeopleIconSelected"),
            UIImage(named: "tabBarIncidentsIconSelected"),
            UIImage(named: "tabBarReportsIconSelected")
        ]
        // get custom tab bar symbols from assets ('unselected' symbols)
        let imagesForUnselectedState = [
            UIImage(named: "tabBarPeopleIconUnselected"),
            UIImage(named: "tabBarIncidentsIconUnselected"),
            UIImage(named: "tabBarReportsIconUnselected")
        ]
        
        // assign custom symbols to appropriate tab bar items
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                self.tabBar.items?[i].selectedImage = imagesForSelectedState[i]?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = imagesForUnselectedState[i]?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        // adjust color(tint) of selected / unselected items in the tab bar
        let selectedColor   = UIColor.white
        let unselectedColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)
        
    }
    

}
