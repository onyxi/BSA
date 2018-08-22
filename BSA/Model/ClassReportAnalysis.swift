//
//  Analysis.swift
//  BSA
//
//  Created by Pete Holdsworth on 24/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

protocol ClassReportAnalysisDelegate{
    func finishedAnalysingClassReportData(dataSet: ClassReportDataSet, for timePeriod: TimePeriod)
}

class ClassReportAnalysis: StudentFetchingDelegate, RAGAssessmentsFetchingDelegate, IncidentsFetchingDelegate {
    
    // Properties:
    var classReportAnalysisDelegate: ClassReportAnalysisDelegate?
    var schoolClass: SchoolClass?
    var timePeriod: TimePeriod = .today
    var students: [Student]?
    var rAGAssessments = [RAGAssessment]()
    var incidents = [Incident]()
    var dataService: DataService?
    
    
    // Initialises required properties and requests students for given School Class object
    func analyseClassReportData(for schoolClass: SchoolClass, from timePeriod: TimePeriod) {
        self.schoolClass = schoolClass
        self.timePeriod = timePeriod
        
        // get students for class
        dataService = DataService()
        dataService?.studentFetchingDelegate = self
        dataService?.rAGAssessmentsFetchingDelegate = self
        dataService?.incidentsFetchingDelegate = self
        
        dataService?.getStudents(for: schoolClass)
    }
    
    // Requests RAG Assessments for fetched Students
    func finishedFetching(students: [Student]){
        self.students = students

        dataService?.getRAGAssessments(for: students, fromTimePeriod: self.timePeriod)
    }
    
    
    func finishedFetching(rAGAssessments: [RAGAssessment]) {
        self.rAGAssessments = rAGAssessments
        dataService?.getIncidents(for: self.students!, fromTimePeriod: self.timePeriod)
    }
    

    func finishedFetching(incidents: [Incident]) {
        self.incidents = incidents
        analyseClassReportData()
    }
    

    
    
    // ---------- Class Report Analysis
    
    func analyseClassReportData() {
        
        guard schoolClass != nil else {
            // error
            return
        }
        
        var redsCount = 0
        var ambersCount = 0
        var greensCount = 0
        
        let incidentsCount = incidents.count
        var totalIntensity: Float = 0.0
        var schoolDayPeriodsCount = 0
        
        for rag in rAGAssessments {
            switch rag.assessment {
            case"red":
                redsCount += 1
            case "amber":
                ambersCount += 1
            case "green":
                greensCount += 1
            default: break
            }
        }
        
        switch timePeriod {
        case .today:
            schoolDayPeriodsCount = DataService.getNumberOfPeriodsAlreadyPastToday()
        case .currentWeek:
            switch DataService.getDayString(for: Date()) {
            case "Monday":
                schoolDayPeriodsCount = DataService.getNumberOfPeriodsAlreadyPastToday()
            case "Tuesday":
                schoolDayPeriodsCount = DataService.getNumberOfPeriodsAlreadyPastToday() + 7
            case "Wednesday":
                schoolDayPeriodsCount = DataService.getNumberOfPeriodsAlreadyPastToday() + 14
            case "Thursday":
                schoolDayPeriodsCount = DataService.getNumberOfPeriodsAlreadyPastToday() + 21
            case "Friday":
                schoolDayPeriodsCount = DataService.getNumberOfPeriodsAlreadyPastToday() + 28
            case "Saturday":
                schoolDayPeriodsCount = DataService.getNumberOfPeriodsAlreadyPastToday() + 35
            case "Sunday":
                schoolDayPeriodsCount = DataService.getNumberOfPeriodsAlreadyPastToday() + 42
            default: break
            }
        case .lastWeek:
            schoolDayPeriodsCount = 49
        case .thisTerm:
            schoolDayPeriodsCount = 588
        case .lastTerm:
            schoolDayPeriodsCount = 588
        case .thisYear:
            schoolDayPeriodsCount = 1365
        case .lastYear:
            schoolDayPeriodsCount = 1400
        case .allTime:
            schoolDayPeriodsCount = 2800
        }
        
        for incident in incidents {
            totalIntensity += incident.intensity!
        }
        
        let ragsTotal = redsCount + ambersCount + greensCount
        let redsPercentage: Double = ragsTotal == 0 ? 0.0 : round((Double(redsCount) / Double(ragsTotal) * 100) * 10) / 10
        let ambersPercentage: Double = ragsTotal == 0 ? 0.0 : round((Double(ambersCount) / Double(ragsTotal) * 100) * 10) / 10
        let greensPercentage: Double = ragsTotal == 0 ? 0.0 : round((Double(greensCount) / Double(ragsTotal) * 100) * 10) / 10
        
        let averageIntensity: Float = incidentsCount == 0 ? 0.0 : Float(totalIntensity) / Float(incidentsCount)
        
        let incidentLikelihood: Double = schoolDayPeriodsCount == 0 ? 0.0 : round((Double(incidentsCount) / Double(schoolDayPeriodsCount) * 100) * 10) / 10
        print(incidentsCount)
        print(schoolDayPeriodsCount)
        
            // Compile and return ClassReportDataSet object through callback method
        classReportAnalysisDelegate?.finishedAnalysingClassReportData(dataSet: ClassReportDataSet(
            entityName: schoolClass!.className,
            timePeriod: timePeriod,
            aveReds: redsPercentage,
            aveAmbers: ambersPercentage,
            aveGreens: greensPercentage,
            aveIntensity: averageIntensity,
            incidentLikelihood: incidentLikelihood), for: timePeriod)
    }
    
    
    
    func finishedFetching(classesWithStudents: [(schoolClass: SchoolClass, students: [Student])]) {
        // needed to conform to protocol - no implementation needed
    }
        
        
        
}
