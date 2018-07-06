//
//  StudentCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 26/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class StudentCell: UITableViewCell {
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var studentNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
