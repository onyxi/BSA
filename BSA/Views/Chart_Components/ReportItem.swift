//
//  ReportItem.swift
//  BSA
//
//  Created by Pete Holdsworth on 02/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class ReportItem: UIView {
    
    // Properties:
    private var type: ReportItemType?
    private var value: Double?
    private var title: UILabel!
    private var figure: UILabel!
    var column: UIView?

    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()

            // set rounded corners
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false

            // setup and add item's title label
        title = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        title.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        title.textColor = .white
        title.textAlignment = .center
        self.addSubview(title)
        
            // setup and add numeric value representation underneath main view
        figure = UILabel(frame: CGRect(x: self.bounds.midX - 30, y: self.bounds.height + 5, width: 60, height: 20))
        figure.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        figure.textAlignment = .center
        self.addSubview(figure)
    }
    
    // Assigns a report data-type to the item and adjusts appearance accordingly
    func setType(to type: ReportItemType) {
        self.type = type
        switch type {
        case .reds:
            self.title.text = "Reds"
            self.layer.backgroundColor = Constants.RED.cgColor
            figure.textColor = Constants.RED_DARK
        case .ambers:
            self.title.text = "Ambers"
            self.layer.backgroundColor = Constants.AMBER.cgColor
            figure.textColor = Constants.AMBER_DARK
        case .greens:
            self.title.text = "Greens"
            self.layer.backgroundColor = Constants.GREEN.cgColor
            figure.textColor = Constants.GREEN_DARK
        case .incidents:
            self.title.text = "Incidents"
            self.layer.backgroundColor = Constants.PURPLE.cgColor
            figure.textColor = Constants.PURPLE_DARK
        }
    }
    
    // Sets the value of the report item
    func setValue(to value: Double) {
        guard value >= 0.0 && value <= 100.0 else { return }
        
        self.value = value
        figure.text = "\(value) %"
    }
    
    // Displays a column representative of the item's value directly above the item's view
    func showColumn() {
        guard type != nil && value != nil else { return }
        column = UIView(frame: CGRect(x: self.bounds.midX - 20, y: -3 - CGFloat(self.value!), width: 40, height: CGFloat(self.value!)))
        switch self.type! {
        case .reds:
            column?.backgroundColor = Constants.RED
            column?.alpha = 0.8
        case .ambers:
            column?.backgroundColor = Constants.AMBER
            column?.alpha = 0.8
        case .greens:
            column?.backgroundColor = Constants.GREEN
            column?.alpha = 0.8
        case .incidents:
            column?.backgroundColor = Constants.PURPLE
            column?.alpha = 0.8
        }
        self.addSubview(column!)
    }
    
    func resetColumn() {
        guard column != nil else { return }
        column!.frame =  CGRect(x: self.bounds.midX - 20, y: -3 , width: 40, height: 0)
    }
    
    // Animates a displayed column from a height of zero to its representative value 
    func animateColumn() {
        guard column != nil else { return }
        
        column!.frame =  CGRect(x: self.bounds.midX - 20, y: -3 , width: 40, height: 0)
        
        UIView.animate(withDuration: Constants.REPORT_ANIMATION_SPEED , delay: Constants.REPORT_ANIMATION_DELAY, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.column!.frame =  CGRect(x: self.bounds.midX - 20, y: -3 - CGFloat(self.value!), width: 40, height: CGFloat(self.value!))
        },completion: nil )
    }
    
}

// Provide constrained values for different available report item data types
enum ReportItemType {
    case reds
    case ambers
    case greens
    case incidents
}
