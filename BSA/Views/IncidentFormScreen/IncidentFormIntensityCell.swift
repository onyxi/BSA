//
//  IncidentFormIntensityCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 30/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class IncidentFormIntensityCell: UITableViewCell {
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellIntensityIndicator: IntensityIndicator!
    @IBOutlet weak var cellButton: UIButton!
    
    var cellPlaceholderLabel: UILabel!
    var arrowView: CellArrowView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
        createPlaceholder()
        cellIntensityIndicator.isHidden = true
    }
    
    func setIntensityIndicatorValue(to value: Float) {
        guard value >= 0.0 && value <= 1.0 else { return }
        cellPlaceholderLabel.text = ""
        cellIntensityIndicator.intensity = value
        cellIntensityIndicator.isHidden = false
    }
    
    func createPlaceholder() {
        cellPlaceholderLabel = UILabel(frame: CGRect(x: self.frame.width - 300, y: self.frame.height/2 - 20, width: 200, height: 40))
        cellPlaceholderLabel.textColor = Constants.LIGHT_GRAY
        cellPlaceholderLabel.text = "Please Indicate..."
        cellPlaceholderLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        cellContentView.addSubview(cellPlaceholderLabel)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
