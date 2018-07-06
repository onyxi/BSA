//
//  Data.swift
//  BSA
//
//  Created by Pete Holdsworth on 13/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class Data {
    
    static func getAccounts () -> [UserAccount] {
        return [
            UserAccount(id: "ac1", name: "Admin", securityLevel: 1),
            UserAccount(id: "ac2", name: "Class A", securityLevel: 2),
            UserAccount(id: "ac3", name: "Class B", securityLevel: 2),
            UserAccount(id: "ac4", name: "Class C", securityLevel: 2),
            UserAccount(id: "ac5", name: "Class D", securityLevel: 2),
        ]
    }
    
    static let accountNames = ["Admin", "Class A", "Class B", "Class C", "Class D"]
    
    static func getDays() -> [DayRAGs] {
        return [
            DayRAGs(p1: 1, p2: 1, p3: 1, p4: nil, p5: 1, p6: nil, p7: nil),
            DayRAGs(p1: 1, p2: 1, p3: 1, p4: nil, p5: 1, p6: 1, p7: nil),
            DayRAGs(p1: 1, p2: 1, p3: nil, p4: 1, p5: 1, p6: 1, p7: 1),
            DayRAGs(p1: 1, p2: 1, p3: 1, p4: 1, p5: 1, p6: 1, p7: 1),
            DayRAGs(p1: 1, p2: 1, p3: 1, p4: 1, p5: 1, p6: 1, p7: 1),
            DayRAGs(p1: 1, p2: 1, p3: 1, p4: 1, p5: 1, p6: 1, p7: 1),
            DayRAGs(p1: 1, p2: 1, p3: 1, p4: 1, p5: 1, p6: 1, p7: 1)
        ]
    }
    
    static func getClassStudents() -> [Student]{
        return [
            Student(id: "st1", firstName: "Timmie", lastName: "Shuck"),
            Student(id: "st2", firstName: "Taber", lastName: "Volker"),
            Student(id: "st3", firstName: "Aluino", lastName: "Pinkerton"),
            Student(id: "st4", firstName: "Matty", lastName: "Roan"),
            Student(id: "st5", firstName: "Latashia", lastName: "Jakes"),
            Student(id: "st6", firstName: "Jase", lastName: "Commins"),
            Student(id: "st7", firstName: "Maurizia", lastName: "Waylett")
        ]
    }
    
    static func getBehaviours() -> [Behaviour] {
        return [
            Behaviour(id: "b1", type: "Kicking"),
            Behaviour(id: "b2", type: "Headbutt"),
            Behaviour(id: "b3", type: "Hitting"),
            Behaviour(id: "b4", type: "Biting"),
            Behaviour(id: "b5", type: "Slapping"),
            Behaviour(id: "b6", type: "Scratching"),
            Behaviour(id: "b7", type: "Clothes-Grabbing"),
            Behaviour(id: "b8", type: "Hair-Pulling")
        ]
    }
    
    static func getStaff() -> [Staff] {
        return [
            Staff(id: "sf1", firstName: "Nicholas", lastName: "Plastow"),
            Staff(id: "sf2", firstName: "Timothy", lastName: "Holdsworth"),
            Staff(id: "sf3", firstName: "Jamie", lastName: "Saunter"),
            Staff(id: "sf4", firstName: "Simonne", lastName: "Ackwood"),
            Staff(id: "sf5", firstName: "Tobin", lastName: "Sharpin"),
            Staff(id: "sf6", firstName: "Odetta", lastName: "Tailby")
        ]
    }
    
    static func getPurposes() -> [Purpose] {
        return [
            Purpose(id: "p1", type: "Social Attention"),
            Purpose(id: "p2", type: "Tangibles"),
            Purpose(id: "p3", type: "Escape"),
            Purpose(id: "p4", type: "Sensory"),
            Purpose(id: "p5", type: "Health"),
            Purpose(id: "p6", type: "Activity Avoidance"),
            Purpose(id: "p7", type: "Unknown")
        ]
    }
    
    static func getDayString(for dateOffset: Int) -> String {
        
        let noonToday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        let requiredDay = Calendar.current.date(byAdding: .day, value: dateOffset, to: noonToday)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: requiredDay)
    }
    
    
    
    
    static func getDateString(for dateOffset: Int) -> String {
        
        let noonToday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        let requiredDay = Calendar.current.date(byAdding: .day, value: dateOffset, to: noonToday)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let dayNumber = dateFormatter.string(from: requiredDay)
        dateFormatter.dateFormat = "MMMM"
        let monthName = dateFormatter.string(from: requiredDay)
        dateFormatter.dateFormat = "YYYY"
        let year = dateFormatter.string(from: requiredDay)
        return "\(dayNumber) \(monthName) \(year)"
        
    }
    
    static func getShortDateString(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }
    
    static func getTimeString(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }

    static func getReportData(for: SchoolClass, from timePeriod: TimePeriod) -> ClassReportDataSet {
        // for testing...
        switch timePeriod {
        case .lastWeek:
            return ClassReportDataSet(entityName: "Class C", timePeriod: timePeriod, aveReds: 3.2, aveAmbers: 5.7, aveGreens: 91.1, aveIntensity: 0.73, incidentLikelihood: 12.7)
        default:
            return ClassReportDataSet(entityName: "Class C", timePeriod: timePeriod, aveReds: 2.7, aveAmbers: 4.5, aveGreens: 92.8, aveIntensity: 0.59, incidentLikelihood: 11.3)
        }
    }
    
    static func getSchoolClass(named className: String) -> SchoolClass {
        // for testing...
        return SchoolClass(id: "C1", name: "Class C", students: [Student(id: "id1", firstName: "s1f", lastName: "s1l")])
    }
}

/// for checking current time against end of periods
extension Date
{
    
    func dateAt(hours: Int, minutes: Int) -> Date
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        
        
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
}

enum TimePeriod: CustomStringConvertible {
    case currentWeek
    case lastWeek
    case thisTerm
    case lastTerm
    case lastYear
    case allTime
    
    var description: String {
        switch self {
        case .currentWeek:
            return "Current Week"
        case .lastWeek:
            return "Last Week"
        case .thisTerm:
            return "This Term"
        case .lastTerm:
            return "Last Term"
        case .lastYear:
            return "Last Year"
        case .allTime:
            return "All Time"
        }
    }
}


