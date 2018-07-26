//
//  RAGsAndIncidentsChartWeekViewXAxisFormatter.swift
//  BSA
//
//  Created by Pete Holdsworth on 19/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit
import Charts

public class RAGsAndIncidentsChartWeekViewXAxisFormatter: NSObject, IAxisValueFormatter {
    
    // Properties:
    var labels = ["Monday", "Tuesday", "Wednesday", "Thrusday", "Friday", "Saturday"]
    
    
    // Returns String values for the indexes of chart axis - to be used as chart axis labels
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return labels[Int(value)]
    }
    
}
