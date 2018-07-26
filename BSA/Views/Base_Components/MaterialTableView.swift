//
//  MaterialTableView.swift
//  BSA
//
//  Created by Pete Holdsworth on 13/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class MaterialTableView: UITableView {

    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // set color and shadow 
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
    }

}
