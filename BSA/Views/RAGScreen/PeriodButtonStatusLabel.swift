//
//  PeriodButtonStatusLabel.swift
//  BSA
//
//  Created by Pete Holdsworth on 05/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class PeriodButtonStatusLabel: UILabel {
    
    override func awakeFromNib() {
        self.textColor = .white
        self.font = UIFont.systemFont(ofSize: 23, weight: .heavy)
        self.textAlignment = .center
        self.text = ""
        self.backgroundColor = .clear
    }

    
    
    func setStatusComplete() {
        self.backgroundColor = Constants.BLUE
        self.text = "Complete"
    }
    
    func setStatusNotComplete() {
        self.backgroundColor = Constants.RED
        self.text = "Not Complete"
    }

}
