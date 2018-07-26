//
//  SelectionIndicator.swift
//  BSA
//
//  Created by Pete Holdsworth on 21/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class SelectionIndicator: UIView {

    override func awakeFromNib() {
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
    }

}
