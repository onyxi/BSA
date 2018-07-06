//
//  ActionButton.swift
//  BSA_v0.0
//
//  Created by Pete Holdsworth on 12/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class ActionButton: MaterialButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTitleColor(UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0), for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.7
    }
    

}
