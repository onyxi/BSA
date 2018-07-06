//
//  BehaviourCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 27/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class BehaviourCell: UITableViewCell {


    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var checkboxImage: UIImageView!
    @IBOutlet weak var behaviourTypeLabel: UILabel!
    
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
