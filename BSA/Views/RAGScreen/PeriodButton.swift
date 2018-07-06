//
//  PeriodButton.swift
//  BSA
//
//  Created by Pete Holdsworth on 15/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class PeriodButton: MaterialButton {
    
//    var periodStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.setTitle("Period \(self.tag)", for: .normal)
        self.setTitleColor(Constants.TEXT_BLACK, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.titleEdgeInsets = UIEdgeInsetsMake(5, 30, 5, 30)
        
//        periodStatus = createStatusIndicator()
//        self.addSubview(periodStatus)
    }
    
//    func createStatusIndicator() -> UILabel {
//        let width = self.bounds.size.width
//        let height = self.bounds.size.height
//
//        let periodStatusIndicator = UILabel(frame: CGRect(x: width - width * 0.45, y: (height / 2) - (height * 0.3), width: width * 0.3, height: height * 0.6))
//        periodStatusIndicator.textColor = .white
//        periodStatusIndicator.font = UIFont.systemFont(ofSize: 23, weight: .heavy)
//        periodStatusIndicator.textAlignment = .center
//        return periodStatusIndicator
//    }
    
//    func updatePeriodStatusFrame() {
//        print (self.bounds)
////        let width = self.frame.size.width
////        let height = self.frame.size.height
////        periodStatus.frame = CGRect(x: width - width * 0.45, y: (height / 2) - (height * 0.3), width: width * 0.3, height: height * 0.6)
//    }
    
//    func setStatusComplete() {
//        periodStatus.backgroundColor = Constants.BLUE
//        periodStatus.text = "Complete"
//    }
//    
//    func setStatusNotComplete() {
//        periodStatus.backgroundColor = Constants.RED
//        periodStatus.text = "Not Complete"
//    }
    
//    override func draw(_ rect: CGRect) {
//        
//        let color = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        
//        context.setLineWidth(5.0)
//        context.setStrokeColor(color.cgColor)
//        context.beginPath()
//        context.move(to: CGPoint(x: rect.maxX - 55, y: rect.midY - 15))
//        context.addLine(to: CGPoint(x: rect.maxX - 40, y: rect.midY))
//        context.addLine(to: CGPoint(x: rect.maxX - 55, y: rect.midY + 15))
//        context.setLineCap(.round)
//        context.strokePath()
//        
//    }
    
    
    
    

}
