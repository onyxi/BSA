//
//  PercentFormatter.swift
//  BSA
//
//  Created by Pete Holdsworth on 21/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation
import Charts

public class PercentFormatter: NSObject, IValueFormatter {
    
    // Returns given chart values with a '%' symbol suffix - to indicate value is a representation of a percentage
    public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "\(Int(value)) %"
    }
    
}
