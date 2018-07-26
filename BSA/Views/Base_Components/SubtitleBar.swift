//
//  SubtitleBar.swift
//  BSA_v0.0
//
//  Created by Pete Holdsworth on 13/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class SubtitleBar: MaterialObject {

    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // set color
        self.layer.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0).cgColor
    }

}
