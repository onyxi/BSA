//
//  IncidentFormTextAreaCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class IncidentFormTextAreaCell: UITableViewCell {

    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellValueLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    
    var cellPlaceholderLabel: UILabel!
    var arrowView: CellArrowView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
        cellValueLabel.text = ""
        createPlaceholder()
    }
    
    func setValue(to value: String) {
        if value.count > 35 {
            cellValueLabel.numberOfLines = 0
        }
        cellValueLabel.text = value
        cellPlaceholderLabel.text = ""
    }
    
    func createPlaceholder() {
        cellPlaceholderLabel = UILabel(frame: CGRect(x: self.frame.width - 300, y: self.frame.height/2 - 20, width: 150, height: 40))
        cellPlaceholderLabel.textColor = Constants.LIGHT_GRAY
        cellPlaceholderLabel.text = "Add Notes..."
        cellPlaceholderLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        cellContentView.addSubview(cellPlaceholderLabel)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
