//
//  MaterialObject.swift
//  BSA_v0.0
//
//  Created by Pete Holdsworth on 12/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class MaterialObject: UIView {

    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // set color, shadow and rounded corners
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
    }
    
}
