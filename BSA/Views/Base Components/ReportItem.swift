//
//  ReportItem.swift
//  BSA
//
//  Created by Pete Holdsworth on 02/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class ReportItem: UIView {
    
    private var type: ReportItemType?
    private var value: Double?
    private var title: UILabel!
    private var figure: UILabel!
    var column: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false

        title = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        title.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        title.textColor = .white
        title.textAlignment = .center
        self.addSubview(title)
        
        figure = UILabel(frame: CGRect(x: self.bounds.midX - 30, y: self.bounds.height + 5, width: 60, height: 20))
        figure.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        figure.textAlignment = .center
        self.addSubview(figure)
    }
    
    func setType(to type: ReportItemType) {
        self.type = type
        switch type {
        case .reds:
            self.title.text = "Reds"
            self.layer.backgroundColor = Constants.RED.cgColor
            figure.textColor = Constants.TEXT_RED
        case .ambers:
            self.title.text = "Ambers"
            self.layer.backgroundColor = Constants.AMBER.cgColor
            figure.textColor = Constants.TEXT_AMBER
        case .greens:
            self.title.text = "Greens"
            self.layer.backgroundColor = Constants.GREEN.cgColor
            figure.textColor = Constants.TEXT_GREEN
        case .incidents:
            self.title.text = "Incidents"
            self.layer.backgroundColor = Constants.PURPLE.cgColor
            figure.textColor = Constants.TEXT_PURPLE
        }
    }
    
    func setValue(to value: Double) {
        self.value = value
        figure.text = "\(value) %"
    }
    
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
    
    func animateColumn() {
        guard column != nil else { return }
        
        column!.frame =  CGRect(x: self.bounds.midX - 20, y: -3 , width: 40, height: 0)
        
        UIView.animate(withDuration: Constants.REPORT_ANIMATION_SPEED , delay: Constants.REPORT_ANIMATION_DELAY, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.column!.frame =  CGRect(x: self.bounds.midX - 20, y: -3 - CGFloat(self.value!), width: 40, height: CGFloat(self.value!))
        },completion: nil )
    }
    
}


enum ReportItemType {
    case reds
    case ambers
    case greens
    case incidents
}
