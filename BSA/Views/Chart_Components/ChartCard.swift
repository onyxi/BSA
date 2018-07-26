//
//  ChartCard.swift
//  BSA
//
//  Created by Pete Holdsworth on 01/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class ChartCard: MaterialObject {

    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // set shadow and rounded corners
        self.layer.backgroundColor = Constants.GRAY_VERY_LIGHT.cgColor
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.3
    }
}
