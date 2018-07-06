//
//  CellArrowView.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class CellArrowView: UIView {
    
//    override init(frame:CGRect) {
//        super.init(frame:frame)
//        self.isOpaque = false
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func draw(_ rect: CGRect) {
        
        
        let color = Constants.LIGHT_GRAY
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineWidth(5.0)
        context.setStrokeColor(color.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: rect.midX - 10, y: rect.midY - 15))
        context.addLine(to: CGPoint(x: rect.midX + 5, y: rect.midY))
        context.addLine(to: CGPoint(x: rect.midX - 10, y: rect.midY + 15))
        context.setLineCap(.round)
        context.strokePath()
        
    }

}
