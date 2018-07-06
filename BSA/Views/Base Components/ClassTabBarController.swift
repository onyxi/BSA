//
//  ClassTabBarController.swift
//  BSA
//
//  Created by Pete Holdsworth on 03/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class ClassTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tabBar.barTintColor = Constants.BLACK
        
        let imagesForSelectedState = [
            UIImage(named: "tabBarRAGIconSelected"),
            UIImage(named: "tabBarIncidentsIconSelected"),
            UIImage(named: "tabBarReportsIconSelected")
        ]
        
        let imagesForUnselectedState = [
            UIImage(named: "tabBarRAGIconUnselected"),
            UIImage(named: "tabBarIncidentsIconUnselected"),
            UIImage(named: "tabBarReportsIconUnselected")
        ]
        
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                
                self.tabBar.items?[i].selectedImage = imagesForSelectedState[i]?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = imagesForUnselectedState[i]?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        let selectedColor   = UIColor.white
        let unselectedColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)

    }
    

    
    

}
