//
//  StudentCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 26/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class StudentCell: UITableViewCell {
    
    // UI handles:
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var studentNameLabel: UILabel!

    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // set cell's color
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
    }

}
