//
//  TransparentCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 03/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class TransparentCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.backgroundColor = UIColor.clear.cgColor
    }

}
