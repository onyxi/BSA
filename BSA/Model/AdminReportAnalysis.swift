//
//  AdminReportAnalysis.swift
//  BSA
//
//  Created by Pete Holdsworth on 27/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import Foundation

protocol AdminReportAnalysisDelegate {
    func finishedAnalysingAdminReportData(dataSet: AdminReportDataSet)
}

class AdminReportAnalysis: RAGAssessmentsFetchingDelegate, IncidentsFetchingDelegate {
    
    var adminReportAnalysisDelegate: AdminReportAnalysisDelegate?
    
    var schoolClass: SchoolClass?
    var timePeriod: TimePeriod = .today
    
    var students: [Student]!
//    var studentsError: Error?
    
    var rAGAssessments = [RAGAssessment]()
//    var ragAssessmentsError: Error?
    
    var incidents = [Incident]()
//    var incidentsError: Error?
    
    var dataService: DataService?
    

    
    
    
    // Returns from storage all report data for a given School-Class recorded in a given time period
    func analyseAdminReportData(for students: [Student]) {
        
        self.students = students
        
        dataService = DataService()
        dataService?.rAGAssessmentsFetchingDelegate = self
        dataService?.incidentsFetchingDelegate = self
        
        dataService?.getAllRAGAssessments(for: students)
        
    }
    
    
    
    
    func finishedFetching(rAGAssessments: [RAGAssessment]) {
        self.rAGAssessments = rAGAssessments
        dataService?.getIncidents(for: self.students)
    }
    
    
    func finishedFetching(incidents: [Incident]) {
        self.incidents = incidents
        analyseAdminReportData()
    }

    
    
    
    // ---------- Admin Report Analysis
    
    
    func analyseAdminReportData() {
        
        var p1RedsCount = 0
        var p2RedsCount = 0
        var p3RedsCount = 0
        var p4RedsCount = 0
        var p5RedsCount = 0
        var p6RedsCount = 0
        var p7RedsCount = 0
        
        var p1AmbersCount = 0
        var p2AmbersCount = 0
        var p3AmbersCount = 0
        var p4AmbersCount = 0
        var p5AmbersCount = 0
        var p6AmbersCount = 0
        var p7AmbersCount = 0
        
        var p1GreensCount = 0
        var p2GreensCount = 0
        var p3GreensCount = 0
        var p4GreensCount = 0
        var p5GreensCount = 0
        var p6GreensCount = 0
        var p7GreensCount = 0
        
        
        var mondayRedsCount = 0
        var tuesdayRedsCount = 0
        var wednesdayRedsCount = 0
        var thursdayRedsCount = 0
        var fridayRedsCount = 0
        
        var mondayAmbersCount = 0
        var tuesdayAmbersCount = 0
        var wednesdayAmbersCount = 0
        var thursdayAmbersCount = 0
        var fridayAmbersCount = 0
        
        var mondayGreensCount = 0
        var tuesdayGreensCount = 0
        var wednesdayGreensCount = 0
        var thursdayGreensCount = 0
        var fridayGreensCount = 0
        
        // ----
        
        var totalIncidents = 0
        
        var p1IncidentsCount = 0
        var p2IncidentsCount = 0
        var p3IncidentsCount = 0
        var l1IncidentsCount = 0
        var l2IncidentsCount = 0
        var p4IncidentsCount = 0
        var p5IncidentsCount = 0
        var p6IncidentsCount = 0
        var p7IncidentsCount = 0
        
        var mondayIncidentsCount = 0
        var tuesdayIncidentsCount = 0
        var wednesdayIncidentsCount = 0
        var thursdayIncidentsCount = 0
        var fridayIncidentsCount = 0
        
        var intensityTotal: Float = 0.0
        
        var kickingCount = 0
        var headbuttCount = 0
        var hittingCount = 0
        var bitingCount = 0
        var slappingCount = 0
        var scratchingCount = 0
        var clothesGrabbingCount = 0
        var hairPullingCount = 0
        
        var socialAttentionCount = 0
        var tangiblesCount = 0
        var escapeCount = 0
        var sensoryCount = 0
        var healthCount = 0
        var activityAvoidanceCount = 0
        var unknownCount = 0
        
        // ----
        
        // iterate through each retreived 'RAG Assessment' object - associated with the group of given students - and extract data
        for rag in rAGAssessments {
            
            // If RAG Assessment was marked as red..
            switch rag.assessment {
            case "red":
                
                // increment green-rag counter for appropriate school-day period
                switch rag.period {
                case "p1":
                    p1RedsCount += 1
                case "p2":
                    p2RedsCount += 1
                case "p3":
                    p3RedsCount += 1
                case "p4":
                    p4RedsCount += 1
                case "p5":
                    p5RedsCount += 1
                case "p6":
                    p6RedsCount += 1
                case "p7":
                    p7RedsCount += 1
                default: break
                }
                
                // increment green-rag counter for appropriate day of the week
                switch DataService.getDayString(for: rag.date) {
                case "Monday":
                    mondayRedsCount += 1
                case "Tuesday":
                    tuesdayRedsCount += 1
                case "Wednesday":
                    wednesdayRedsCount += 1
                case "Thursday":
                    thursdayRedsCount += 1
                case "Friday":
                    fridayRedsCount += 1
                default: break
                }
                
            // If RAG Assessment was marked as amber..
            case "amber":
                
                // increment green-rag counter for appropriate school-day period
                switch rag.period {
                case "p1":
                    p1AmbersCount += 1
                case "p2":
                    p2AmbersCount += 1
                case "p3":
                    p3AmbersCount += 1
                case "p4":
                    p4AmbersCount += 1
                case "p5":
                    p5AmbersCount += 1
                case "p6":
                    p6AmbersCount += 1
                case "p7":
                    p7AmbersCount += 1
                default: break
                }
                
                // increment green-rag counter for appropriate day of the week
                switch DataService.getDayString(for: rag.date) {
                case "Monday":
                    mondayAmbersCount += 1
                case "Tuesday":
                    tuesdayAmbersCount += 1
                case "Wednesday":
                    wednesdayAmbersCount += 1
                case "Thursday":
                    thursdayAmbersCount += 1
                case "Friday":
                    fridayAmbersCount += 1
                default: break
                }
                
            // If RAG Assessment was marked as green..
            case "green":
                
                // increment green-rag counter for appropriate school-day period
                switch rag.period {
                case "p1":
                    p1GreensCount += 1
                case "p2":
                    p2GreensCount += 1
                case "p3":
                    p3GreensCount += 1
                case "p4":
                    p4GreensCount += 1
                case "p5":
                    p5GreensCount += 1
                case "p6":
                    p6GreensCount += 1
                case "p7":
                    p7GreensCount += 1
                default: break
                }
                
                // increment green-rag counter for appropriate day of the week
                switch DataService.getDayString(for: rag.date) {
                case "Monday":
                    mondayGreensCount += 1
                case "Tuesday":
                    tuesdayGreensCount += 1
                case "Wednesday":
                    wednesdayGreensCount += 1
                case "Thursday":
                    thursdayGreensCount += 1
                case "Friday":
                    fridayGreensCount += 1
                default: break
                }
                
            case "na":
                break
            case .none:
                break
            default: break
            }
        }
        
        // ----
        
        // iterate through each retreived 'Incident' object - associated with the group of given students - and extract data
        for incident in incidents {
            
            // increment running total of incident occurences
            totalIncidents += 1
            
            // increment appropriate counter for incident occurrence by school-day period
            if incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.P1_END_HOURS, minutes: Constants.P1_END_MINS) {
                p1IncidentsCount += 1
            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.P1_END_HOURS, minutes: Constants.P1_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.P2_END_HOURS, minutes: Constants.P2_END_MINS) {
                p2IncidentsCount += 1
            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.P2_END_HOURS, minutes: Constants.P2_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.P3_END_HOURS, minutes: Constants.P3_END_MINS) {
                p3IncidentsCount += 1
            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.P3_END_HOURS, minutes: Constants.P3_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.L1_END_HOURS, minutes: Constants.L1_END_MINS) {
                l1IncidentsCount += 1
            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.L1_END_HOURS, minutes: Constants.L1_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.L2_END_HOURS, minutes: Constants.L2_END_MINS) {
                l2IncidentsCount += 1
            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.L2_END_HOURS, minutes: Constants.L2_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.P4_END_HOURS, minutes: Constants.P4_END_MINS) {
                p4IncidentsCount += 1
            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.P4_END_HOURS, minutes: Constants.P4_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.P5_END_HOURS, minutes: Constants.P5_END_MINS) {
                p5IncidentsCount += 1
            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.P5_END_HOURS, minutes: Constants.P5_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.P6_END_HOURS, minutes: Constants.P6_END_MINS) {
                p6IncidentsCount += 1
            } else if incident.dateTime! >= incident.dateTime!.dateAt(hours: Constants.P6_END_HOURS, minutes: Constants.P6_END_MINS) && incident.dateTime! < incident.dateTime!.dateAt(hours: Constants.P7_END_HOURS, minutes: Constants.P7_END_MINS) {
                p7IncidentsCount += 1
            }
            
            // increment appropriate counter for incident occurrence by day of week
            switch DataService.getDayString(for: incident.dateTime!)  {
            case "Monday":
                mondayIncidentsCount += 1
            case "Tuesday":
                tuesdayIncidentsCount += 1
            case "Wednesday":
                wednesdayIncidentsCount += 1
            case "Thursday":
                thursdayIncidentsCount += 1
            case "Friday":
                fridayIncidentsCount += 1
            default: break
            }
            
            // add incident intensity to running total
            intensityTotal += incident.intensity!
            
            // increment appropriate incident-behaviour counter for each occurrence in incidents
            for behaviour in incident.behaviours! {
                switch behaviour {
                case Constants.BEHAVIOURS.kicking:
                    kickingCount += 1
                case Constants.BEHAVIOURS.headbutt:
                    headbuttCount += 1
                case Constants.BEHAVIOURS.hitting:
                    hittingCount += 1
                case Constants.BEHAVIOURS.biting:
                    bitingCount += 1
                case Constants.BEHAVIOURS.slapping:
                    slappingCount += 1
                case Constants.BEHAVIOURS.scratching:
                    scratchingCount += 1
                case Constants.BEHAVIOURS.clothesGrabbing:
                    clothesGrabbingCount += 1
                case Constants.BEHAVIOURS.hairPulling:
                    hairPullingCount += 1
                default: break
                }
            }
            
            // increment appropriate incident-purpose counter for each occurrence in incidents
            for purpose in incident.purposes! {
                switch purpose {
                case Constants.PURPOSES.socialAttention:
                    socialAttentionCount += 1
                case Constants.PURPOSES.tangibles:
                    tangiblesCount += 1
                case Constants.PURPOSES.escape:
                    escapeCount += 1
                case Constants.PURPOSES.sensory:
                    sensoryCount += 1
                case Constants.PURPOSES.health:
                    healthCount += 1
                case Constants.PURPOSES.activityAvoidance:
                    activityAvoidanceCount += 1
                case Constants.PURPOSES.unknown:
                    unknownCount += 1
                default: break
                }
            }
            
        }
        
        // ----
        
        // Calculate total number of RAG assessments - by period
        let p1Total = p1RedsCount + p1AmbersCount + p1GreensCount
        let p2Total = p2RedsCount + p2AmbersCount + p2GreensCount
        let p3Total = p3RedsCount + p3AmbersCount + p3GreensCount
        let p4Total = p4RedsCount + p4AmbersCount + p4GreensCount
        let p5Total = p5RedsCount + p5AmbersCount + p5GreensCount
        let p6Total = p6RedsCount + p6AmbersCount + p6GreensCount
        let p7Total = p7RedsCount + p7AmbersCount + p7GreensCount
        
        // Calculate percentage of 'Red' RAG assessments - by period
        let p1RedsPercent: Double = p1Total == 0 ? 0.0 : Double(p1RedsCount)/Double(p1Total) * 100
        let p2RedsPercent: Double = p2Total == 0 ? 0.0 : Double(p2RedsCount)/Double(p2Total) * 100
        let p3RedsPercent: Double = p3Total == 0 ? 0.0 : Double(p3RedsCount)/Double(p3Total) * 100
        let p4RedsPercent: Double = p4Total == 0 ? 0.0 : Double(p4RedsCount)/Double(p4Total) * 100
        let p5RedsPercent: Double = p5Total == 0 ? 0.0 : Double(p5RedsCount)/Double(p5Total) * 100
        let p6RedsPercent: Double = p6Total == 0 ? 0.0 : Double(p6RedsCount)/Double(p6Total) * 100
        let p7RedsPercent: Double = p7Total == 0 ? 0.0 : Double(p7RedsCount)/Double(p7Total) * 100
        
        // Calculate percentage of 'Amber' RAG assessments - by period
        let p1AmbersPercent: Double = p1Total == 0 ? 0.0 : Double(p1AmbersCount)/Double(p1Total) * 100
        let p2AmbersPercent: Double = p2Total == 0 ? 0.0 : Double(p2AmbersCount)/Double(p2Total) * 100
        let p3AmbersPercent: Double = p3Total == 0 ? 0.0 : Double(p3AmbersCount)/Double(p3Total) * 100
        let p4AmbersPercent: Double = p4Total == 0 ? 0.0 : Double(p4AmbersCount)/Double(p4Total) * 100
        let p5AmbersPercent: Double = p5Total == 0 ? 0.0 : Double(p5AmbersCount)/Double(p5Total) * 100
        let p6AmbersPercent: Double = p6Total == 0 ? 0.0 : Double(p6AmbersCount)/Double(p6Total) * 100
        let p7AmbersPercent: Double = p7Total == 0 ? 0.0 : Double(p7AmbersCount)/Double(p7Total) * 100
        
        // Calculate percentage of 'Green' RAG assessments - by period
        let p1GreensPercent: Double = p1Total == 0 ? 0.0 : Double(p1GreensCount)/Double(p1Total) * 100
        let p2GreensPercent: Double = p2Total == 0 ? 0.0 : Double(p2GreensCount)/Double(p2Total) * 100
        let p3GreensPercent: Double = p3Total == 0 ? 0.0 : Double(p3GreensCount)/Double(p3Total) * 100
        let p4GreensPercent: Double = p4Total == 0 ? 0.0 : Double(p4GreensCount)/Double(p4Total) * 100
        let p5GreensPercent: Double = p5Total == 0 ? 0.0 : Double(p5GreensCount)/Double(p5Total) * 100
        let p6GreensPercent: Double = p6Total == 0 ? 0.0 : Double(p6GreensCount)/Double(p6Total) * 100
        let p7GreensPercent: Double = p7Total == 0 ? 0.0 : Double(p7GreensCount)/Double(p7Total) * 100
        
        // Calculate total number of RAG assessments - by day
        let mondayTotal = mondayRedsCount + mondayAmbersCount + mondayGreensCount
        let tuesdayTotal = tuesdayRedsCount + tuesdayAmbersCount + tuesdayGreensCount
        let wednesdayTotal = wednesdayRedsCount + wednesdayAmbersCount + wednesdayGreensCount
        let thursdayTotal = thursdayRedsCount + thursdayAmbersCount + thursdayGreensCount
        let fridayTotal = fridayRedsCount + fridayAmbersCount + fridayGreensCount
        
        // Calculate percentage of 'Red' RAG assessments - by day
        let mondayRedsPercent: Double = mondayTotal == 0 ? 0.0 : Double(mondayRedsCount)/Double(mondayTotal) * 100
        let tuesdayRedsPercent: Double = tuesdayTotal == 0 ? 0.0 : Double(tuesdayRedsCount)/Double(tuesdayTotal) * 100
        let wednesdayRedsPercent: Double = wednesdayTotal == 0 ? 0.0 : Double(wednesdayRedsCount)/Double(wednesdayTotal) * 100
        let thursdayRedsPercent: Double = thursdayTotal == 0 ? 0.0 : Double(thursdayRedsCount)/Double(thursdayTotal) * 100
        let fridayRedsPercent: Double = fridayTotal == 0 ? 0.0 : Double(fridayRedsCount)/Double(fridayTotal) * 100
        
        // Calculate percentage of 'Amber' RAG assessments - by day
        let mondayAmbersPercent: Double = mondayTotal == 0 ? 0.0 : Double(mondayAmbersCount)/Double(mondayTotal) * 100
        let tuesdayAmbersPercent: Double = tuesdayTotal == 0 ? 0.0 : Double(tuesdayAmbersCount)/Double(tuesdayTotal) * 100
        let wednesdayAmbersPercent: Double = wednesdayTotal == 0 ? 0.0 : Double(wednesdayAmbersCount)/Double(wednesdayTotal) * 100
        let thursdayAmbersPercent: Double = thursdayTotal == 0 ? 0.0 : Double(thursdayAmbersCount)/Double(thursdayTotal) * 100
        let fridayAmbersPercent: Double = fridayTotal == 0 ? 0.0 : Double(fridayAmbersCount)/Double(fridayTotal) * 100
        
        // Calculate percentage of 'Green' RAG assessments - by day
        let mondayGreensPercent: Double = mondayTotal == 0 ? 0.0 : Double(mondayGreensCount)/Double(mondayTotal) * 100
        let tuesdayGreensPercent: Double = tuesdayTotal == 0 ? 0.0 : Double(tuesdayGreensCount)/Double(tuesdayTotal) * 100
        let wednesdayGreensPercent: Double = wednesdayTotal == 0 ? 0.0 : Double(wednesdayGreensCount)/Double(wednesdayTotal) * 10
        let thursdayGreensPercent: Double = thursdayTotal == 0 ? 0.0 : Double(thursdayGreensCount)/Double(thursdayTotal) * 100
        let fridayGreensPercent: Double = fridayTotal == 0 ? 0.0 : Double(fridayGreensCount)/Double(fridayTotal) * 100
        
        // Calculate Day View Incident percentages - by period
        let p1IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(p1IncidentsCount)/Double(totalIncidents) * 100
        let p2IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(p2IncidentsCount)/Double(totalIncidents) * 100
        let p3IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(p3IncidentsCount)/Double(totalIncidents) * 100
        let l1IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(l1IncidentsCount)/Double(totalIncidents) * 100
        let l2IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(l2IncidentsCount)/Double(totalIncidents) * 100
        let p4IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(p4IncidentsCount)/Double(totalIncidents) * 100
        let p5IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(p5IncidentsCount)/Double(totalIncidents) * 100
        let p6IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(p6IncidentsCount)/Double(totalIncidents) * 100
        let p7IncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(p7IncidentsCount)/Double(totalIncidents) * 100
        
        // Calculate Week View Incident percentages - by day
        let mondayIncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(mondayIncidentsCount)/Double(totalIncidents) * 100
        let tuesdayIncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(tuesdayIncidentsCount)/Double(totalIncidents) * 100
        let wednesdayIncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(wednesdayIncidentsCount)/Double(totalIncidents) * 100
        let thursdayIncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(thursdayIncidentsCount)/Double(totalIncidents) * 100
        let fridayIncidentsPercent: Double = totalIncidents == 0 ? 0.0 : Double(fridayIncidentsCount)/Double(totalIncidents) * 100
        
        // Package-up Day View percentages - by period
        let dayViewReds: [Double] = [p1RedsPercent, p2RedsPercent, p3RedsPercent, 0.0, 0.0, p4RedsPercent, p5RedsPercent, p6RedsPercent, p7RedsPercent]
        let dayViewAmbers: [Double] = [p1AmbersPercent, p2AmbersPercent, p3AmbersPercent, 0.0, 0.0, p4AmbersPercent, p5AmbersPercent, p6AmbersPercent, p7AmbersPercent]
        let dayViewGreens: [Double] = [p1GreensPercent, p2GreensPercent, p3GreensPercent, 0.0, 0.0, p4GreensPercent, p5GreensPercent, p6GreensPercent, p7GreensPercent]
        let dayViewIncidents: [Double] = [p1IncidentsPercent, p2IncidentsPercent, p3IncidentsPercent, l1IncidentsPercent, l2IncidentsPercent, p4IncidentsPercent, p5IncidentsPercent, p6IncidentsPercent, p7IncidentsPercent]
        
        // Package-up Week View percentages - per day
        let weekViewReds: [Double] = [mondayRedsPercent, tuesdayRedsPercent, wednesdayRedsPercent, thursdayRedsPercent, fridayRedsPercent]
        let weekViewAmbers: [Double] = [mondayAmbersPercent, tuesdayAmbersPercent, wednesdayAmbersPercent, thursdayAmbersPercent, fridayAmbersPercent]
        let weekViewGreens: [Double] = [mondayGreensPercent, tuesdayGreensPercent, wednesdayGreensPercent, thursdayGreensPercent, fridayGreensPercent]
        let weekViewIncidents: [Double] = [mondayIncidentsPercent, tuesdayIncidentsPercent, wednesdayIncidentsPercent, thursdayIncidentsPercent, fridayIncidentsPercent]
        
        // Calculate average incident intensity
        let averageIncidentIntensity: Float = totalIncidents == 0 ? 0.0 : round((intensityTotal / Float(totalIncidents)) * 10) / 10
        
        // Calculate Behaviour-types percentages
        let kicking: Double = totalIncidents == 0 ? 0.0 : Double(kickingCount)/Double(totalIncidents) * 100
        let headbutt: Double = totalIncidents == 0 ? 0.0 : Double(headbuttCount)/Double(totalIncidents) * 100
        let hitting: Double = totalIncidents == 0 ? 0.0 : Double(hittingCount)/Double(totalIncidents) * 100
        let biting: Double = totalIncidents == 0 ? 0.0 : Double(bitingCount)/Double(totalIncidents) * 100
        let slapping: Double = totalIncidents == 0 ? 0.0 : Double(slappingCount)/Double(totalIncidents) * 100
        let scratching: Double = totalIncidents == 0 ? 0.0 : Double(scratchingCount)/Double(totalIncidents) * 100
        let clothesGrabbing: Double = totalIncidents == 0 ? 0.0 : Double(clothesGrabbingCount)/Double (totalIncidents) * 100
        let hairPulling: Double = totalIncidents == 0 ? 0.0 : Double(hairPullingCount)/Double(totalIncidents) * 100
        
        // Calculate Purpose-types percentages
        let socialAttention: Double = totalIncidents == 0 ? 0.0 : Double(socialAttentionCount)/Double(totalIncidents) * 100
        let tangibles: Double = totalIncidents == 0 ? 0.0 : Double(tangiblesCount)/Double(totalIncidents) * 100
        let escape: Double = totalIncidents == 0 ? 0.0 : Double(escapeCount)/Double(totalIncidents) * 100
        let sensory: Double = totalIncidents == 0 ? 0.0 : Double(sensoryCount)/Double(totalIncidents) * 100
        let health: Double = totalIncidents == 0 ? 0.0 : Double(healthCount)/Double(totalIncidents) * 100
        let activityAvoidance: Double = totalIncidents == 0 ? 0.0 : Double(activityAvoidanceCount)/Double(totalIncidents) * 100
        let unknown: Double = totalIncidents == 0 ? 0.0 : Double(unknownCount)/Double(totalIncidents) * 100
        
        // Compile and return AdminReportDataSet object through callback method
        adminReportAnalysisDelegate?.finishedAnalysingAdminReportData(dataSet: AdminReportDataSet(dayViewReds: (p1: dayViewReds[0], p2: dayViewReds[1], p3: dayViewReds[2], l1: dayViewReds[3], l2: dayViewReds[4], p4: dayViewReds[5], p5: dayViewReds[6], p6: dayViewReds[7], p7: dayViewReds[8]), dayViewAmbers: (p1: dayViewAmbers[0], p2: dayViewAmbers[1], p3: dayViewAmbers[2], l1: dayViewAmbers[3], l2: dayViewAmbers[4], p4: dayViewAmbers[5], p5: dayViewAmbers[6], p6: dayViewAmbers[7], p7: dayViewAmbers[8]), dayViewGreens: (p1: dayViewGreens[0], p2: dayViewGreens[1], p3: dayViewGreens[2], l1: dayViewGreens[3], l2: dayViewGreens[4], p4: dayViewGreens[5], p5: dayViewGreens[6], p6: dayViewGreens[7], p7: dayViewGreens[8]), dayViewIncidents: (p1: dayViewIncidents[0], p2: dayViewIncidents[1], p3: dayViewIncidents[2], l1: dayViewIncidents[3], l2: dayViewIncidents[4], p4: dayViewIncidents[5], p5: dayViewIncidents[6], p6: dayViewIncidents[7], p7: dayViewIncidents[8]), weekViewReds: (mon: weekViewReds[0], tue: weekViewReds[1], wed: weekViewReds[2], thu: weekViewReds[3], fri: weekViewReds[4]), weekViewAmbers: (mon: weekViewAmbers[0], tue: weekViewAmbers[1], wed: weekViewAmbers[2], thu: weekViewAmbers[3], fri: weekViewAmbers[4]), weekViewGreens: (mon: weekViewGreens[0], tue: weekViewGreens[1], wed: weekViewGreens[2], thu: weekViewGreens[3], fri: weekViewGreens[4]), weekViewIncidents: (mon: weekViewIncidents[0], tue: weekViewIncidents[1], wed: weekViewIncidents[2], thu: weekViewIncidents[3], fri: weekViewIncidents[4]), totalIncidents: totalIncidents, averageIncidentIntensity: averageIncidentIntensity, behaviours: (kicking: kicking, headbutt: headbutt, hitting: hitting, biting: biting, slapping: slapping, scratching: scratching, clothesGrabbing: clothesGrabbing, hairPulling: hairPulling), purposes: (socialAttention: socialAttention, tangibles: tangibles, escape: escape, sensory: sensory, health: health, activityAvoidance: activityAvoidance, unknown: unknown)))
        
    }
    
    
    
    func finishedFetching(classesWithStudents: [(schoolClass: SchoolClass, students: [Student])]) {
        // no implementation needed
    }
    
    
    
}
