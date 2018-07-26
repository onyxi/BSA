//
//  AdminReportDataSet.swift
//  BSA
//
//  Created by Pete Holdsworth on 21/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

class AdminReportDataSet {
    
    // Properties:
    var dayViewReds: (p1: Double, p2: Double, p3: Double, l1: Double, l2: Double, p4: Double, p5: Double, p6: Double, p7: Double)!
    var dayViewAmbers: (p1: Double, p2: Double, p3: Double, l1: Double, l2: Double, p4: Double, p5: Double, p6: Double, p7: Double)!
    var dayViewGreens: (p1: Double, p2: Double, p3: Double, l1: Double, l2: Double, p4: Double, p5: Double, p6: Double, p7: Double)!
    var dayViewIncidents: (p1: Double, p2: Double, p3: Double, l1: Double, l2: Double, p4: Double, p5: Double, p6: Double, p7: Double)!
    
    var weekViewReds: (mon: Double, tue: Double, wed: Double, thu: Double, fri: Double)!
    var weekViewAmbers: (mon: Double, tue: Double, wed: Double, thu: Double, fri: Double)!
    var weekViewGreens: (mon: Double, tue: Double, wed: Double, thu: Double, fri: Double)!
    var weekViewIncidents: (mon: Double, tue: Double, wed: Double, thu: Double, fri: Double)!
    
    var totalIncidents: Int!
    
    var averageIncidentIntensity: Float!
    
    var behaviours: (
        kicking: Double,
        headbutt: Double,
        hitting: Double,
        biting: Double,
        slapping: Double,
        scratching: Double,
        clothesGrabbing: Double,
        hairPulling: Double
    )!
    
    var purposes: (
        socialAttention: Double,
        tangibles: Double,
        escape: Double,
        sensory: Double,
        health: Double,
        activityAvoidance: Double,
        unknown: Double
    )!
    
    // Custom initialiser
    init(
        dayViewReds: (p1: Double, p2: Double, p3: Double, l1: Double, l2: Double, p4: Double, p5: Double, p6: Double, p7: Double),
        dayViewAmbers: (p1: Double, p2: Double, p3: Double, l1: Double, l2: Double, p4: Double, p5: Double, p6: Double, p7: Double),
        dayViewGreens: (p1: Double, p2: Double, p3: Double, l1: Double, l2: Double, p4: Double, p5: Double, p6: Double, p7: Double),
        dayViewIncidents: (p1: Double, p2: Double, p3: Double, l1: Double, l2: Double, p4: Double, p5: Double, p6: Double, p7: Double),
        weekViewReds: (mon: Double, tue: Double, wed: Double, thu: Double, fri: Double),
        weekViewAmbers: (mon: Double, tue: Double, wed: Double, thu: Double, fri: Double),
        weekViewGreens: (mon: Double, tue: Double, wed: Double, thu: Double, fri: Double),
        weekViewIncidents: (mon: Double, tue: Double, wed: Double, thu: Double, fri: Double),
        totalIncidents: Int,
        averageIncidentIntensity: Float,
        behaviours: (kicking: Double, headbutt: Double, hitting: Double, biting: Double, slapping: Double, scratching: Double, clothesGrabbing: Double, hairPulling: Double),
        purposes: (socialAttention: Double, tangibles: Double, escape: Double, sensory: Double, health: Double, activityAvoidance: Double, unknown: Double)
        ) {
        self.dayViewReds = dayViewReds
        self.dayViewAmbers = dayViewAmbers
        self.dayViewGreens = dayViewGreens
        self.dayViewIncidents = dayViewIncidents
        self.weekViewReds = weekViewReds
        self.weekViewAmbers = weekViewAmbers
        self.weekViewGreens = weekViewGreens
        self.weekViewIncidents = weekViewIncidents
        self.totalIncidents = totalIncidents
        self.averageIncidentIntensity = averageIncidentIntensity
        self.behaviours = behaviours
        self.purposes = purposes
    }
    
}
