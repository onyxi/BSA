//
//  TransparentCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 03/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class TransparentCell: UITableViewCell {

    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // set background color (transparent)
        self.layer.backgroundColor = UIColor.clear.cgColor
    }

}
