//
//  PurposeCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 27/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class PurposeCell: UITableViewCell {
    
    // UI handles:
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var checkboxImage: UIImageView!
    @IBOutlet weak var purposeTypeLabel: UILabel!

    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // set cell's color
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
    }

}
