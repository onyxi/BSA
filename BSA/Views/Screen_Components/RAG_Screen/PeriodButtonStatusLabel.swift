//
//  PeriodButtonStatusLabel.swift
//  BSA
//
//  Created by Pete Holdsworth on 05/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class PeriodButtonStatusLabel: UILabel {
    
    // Configure view appearance when loaded
    override func awakeFromNib() {
        
            // set colors and text styles, with default text value as empty
        self.textColor = .white
        self.font = UIFont.systemFont(ofSize: 23, weight: .heavy)
        self.textAlignment = .center
        self.text = ""
        self.backgroundColor = .clear
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }
    
    // clear label before updating
    func clearStatusLabel() {
        self.backgroundColor = .clear
         self.text = ""
    }

    // Update label color and text value to reflect when a given period's RAG assessment has been completed
    func setStatusComplete() {
        self.backgroundColor = Constants.BLUE
        self.text = "Complete"
    }
    
    // Update label color and text value to reflect when a given period's RAG assessment has not been completed, and is late
    func setStatusNotComplete() {
        self.backgroundColor = Constants.RED
        self.text = "Not Complete"
    }

}
