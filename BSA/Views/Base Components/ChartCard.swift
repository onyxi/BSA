//
//  ChartCard.swift
//  BSA
//
//  Created by Pete Holdsworth on 01/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class ChartCard: MaterialObject {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.backgroundColor = Constants.CHART_CARD_GRAY.cgColor
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 2

        self.layer.shadowOpacity = 0.3
    }
}
