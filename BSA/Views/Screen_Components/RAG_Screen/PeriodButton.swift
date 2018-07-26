//
//  PeriodButton.swift
//  BSA
//
//  Created by Pete Holdsworth on 15/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class PeriodButton: MaterialButton {

    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // set title text, position and colors
        self.backgroundColor = .white
        self.setTitle("Period \(self.tag)", for: .normal)
        self.setTitleColor(Constants.BLACK, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.titleEdgeInsets = UIEdgeInsetsMake(5, 30, 5, 30)
        self.layer.cornerRadius = 7
    }

}
