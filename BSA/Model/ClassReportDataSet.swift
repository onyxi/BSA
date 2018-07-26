//
//  ClassReportDataSet.swift
//  BSA
//
//  Created by Pete Holdsworth on 02/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

class ClassReportDataSet {
    
    // Properties:
    var entityName: String!
    var timePeriod: TimePeriod!
    var averageReds: Double!
    var averageAmbers: Double!
    var averageGreens: Double!
    var averageIntensity: Float!
    var likelihoodOfIncident: Double!
    
    // Custom initialiser
    init(entityName: String, timePeriod: TimePeriod, aveReds: Double, aveAmbers: Double, aveGreens: Double, aveIntensity: Float, incidentLikelihood: Double) {
        self.entityName = entityName
        self.timePeriod = timePeriod
        self.averageReds = aveReds
        self.averageAmbers = aveAmbers
        self.averageGreens = aveGreens
        self.averageIntensity = aveIntensity
        self.likelihoodOfIncident = incidentLikelihood
    }
    
}
