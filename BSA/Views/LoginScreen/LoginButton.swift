//
//  LoginButton.swift
//  BSA
//
//  Created by Pete Holdsworth on 13/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class LoginButton: ActionButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
            self.setTitle("Log In", for: .normal)
    }
    
}
