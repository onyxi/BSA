//
//  LoginButton.swift
//  BSA
//
//  Created by Pete Holdsworth on 13/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class LoginButton: ActionButton {
    
    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // set title text
        self.setTitle("Log In", for: .normal)
    }
    
}
