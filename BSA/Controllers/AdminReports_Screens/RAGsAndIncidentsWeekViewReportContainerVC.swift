//
//  RAGsAndIncidentsWeekViewReportContainerVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 18/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit
import Charts

class RAGsAndIncidentsWeekViewReportContainerVC: UIViewController {

    // UI handles:
    @IBOutlet weak var reportSummaryLabel: UILabel!
    @IBOutlet weak var RAGsChartLegendLabel: UILabel!
    @IBOutlet weak var RAGsChartReds: ReportItem!
    @IBOutlet weak var RAGsChartAmbers: ReportItem!
    @IBOutlet weak var RAGsChartGreens: ReportItem!
    @IBOutlet weak var IncidentsChartLegendLabel: UILabel!
    @IBOutlet weak var IncidentsChartIncidents: ReportItem!
    @IBOutlet weak var chartView: CombinedChartView!
    
    
    // Properties:
        // inital empty values for the combined bar/line chart
    var redBarValues = [0.0, 0.0, 0.0, 0.0, 0.0]
    var amberBarValues = [0.0, 0.0, 0.0, 0.0, 0.0]
    var greenBarValues = [0.0, 0.0, 0.0, 0.0, 0.0]
    var incidentLineValues = [0.0, 0.0, 0.0, 0.0, 0.0]
    var redAverageValue = 0.0
    var amberAverageValue = 0.0
    var greenAverageValue = 0.0
    var incidentAverageValue = 0.0
    
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // set view appearance
        view.backgroundColor = .white
        
            // set up chart view's appearance and give initial empty data set
        setupCharts()
        updateCharts()
        
    }
    
    // Hides the container view
    func hide() {
        self.view.isHidden = true
    }

    // Configures charts' appearance and properties
    func setupCharts() {
        
        // setup report title
        let titleString = "Red, Amber and Green assessments given and Incident occurrences by school day" as NSString
        let attributedString = NSMutableAttributedString(string: titleString as String, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0)])
        let boldFontAttribute = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17.0)]
        attributedString.addAttributes(boldFontAttribute, range: titleString.range(of: "by school day"))
        reportSummaryLabel.attributedText = attributedString
        reportSummaryLabel.baselineAdjustment = .alignCenters
        
        // ----
        
        // setup RAGs-and-Incidents Chart
            // congfigure left-axis
        let leftAxis = chartView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 100
        leftAxis.drawGridLinesEnabled = false
        leftAxis.enabled = false
        
            // congfigure right-axis
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false
        
            // congfigure x-axis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 5
        xAxis.granularity = 1
        xAxis.centerAxisLabelsEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.setLabelCount(6, force: true)
        let axisFormatter:RAGsAndIncidentsChartWeekViewXAxisFormatter = RAGsAndIncidentsChartWeekViewXAxisFormatter()
        xAxis.valueFormatter = axisFormatter
        chartView.xAxis.valueFormatter = xAxis.valueFormatter
        xAxis.centerAxisLabelsEnabled = true
        xAxis.labelFont = Constants.CHART_AXIS_LABEL_FONT
        
            // congfigure legend/labels
        chartView.chartDescription?.text = ""
        chartView.legend.enabled = false
        chartView.drawValueAboveBarEnabled = true
        
            // configure chart view drawing and interaction
        chartView.drawOrder = [2, 0]
        chartView.isUserInteractionEnabled = false
        
        // ----
        
            // setup RAGs chart
        RAGsChartLegendLabel.text = "Average spread of assessments given per day"
        RAGsChartReds.setType(to: .reds)
        RAGsChartAmbers.setType(to: .ambers)
        RAGsChartGreens.setType(to: .greens)

        // ----
        
            // Setup Incidents Chart
        IncidentsChartLegendLabel.text = "Liklihood of an incident occurring in any given day"
        IncidentsChartIncidents.setType(to: .incidents)
    }
    
    
    // Unpacks data sets for use in the charts - first checking to make sure that a valid data set has been given
    func addChartData(chartData: (redValues: [Double], amberValues: [Double], greenValues: [Double], incidentValues: [Double])) {
        
            // check to make sure data set is valid
        guard chartData.redValues.count == 5, chartData.amberValues.count == 5, chartData.greenValues.count == 5, chartData.incidentValues.count == 5 else {
            // invalid data given
            print("invalid data for week view report")
            return
        }
            // unpack data
        redBarValues = chartData.redValues
        amberBarValues = chartData.amberValues
        greenBarValues = chartData.greenValues
        incidentLineValues = chartData.incidentValues
        redAverageValue = DataService.getAverage(of: redBarValues)
        amberAverageValue = DataService.getAverage(of: amberBarValues)
        greenAverageValue = DataService.getAverage(of: greenBarValues)
        incidentAverageValue = DataService.getAverage(of: incidentLineValues)
        
            // update charts
        updateCharts()
    }
    
    // Updates all report charts with currently held data values
    func updateCharts() {

        // set RAGs-and-Incidents Chart data
        
            // congfigure layout of bars
        let groupSpace = 0.7
        let barSpace = 0.0
        let barWidth = 0.1
        
            // add values for 'red' bars
        let bar1Entry1 = BarChartDataEntry(x: 0, yValues: [redBarValues[0]])
        let bar1Entry2 = BarChartDataEntry(x: 0, yValues: [redBarValues[1]])
        let bar1Entry3 = BarChartDataEntry(x: 0, yValues: [redBarValues[2]])
        let bar1Entry4 = BarChartDataEntry(x: 0, yValues: [redBarValues[3]])
        let bar1Entry5 = BarChartDataEntry(x: 0, yValues: [redBarValues[4]])
        let barDataSet1 = BarChartDataSet(values: [bar1Entry1, bar1Entry2, bar1Entry3, bar1Entry4, bar1Entry5], label: nil)
        barDataSet1.setColor(UIColor(red: 255/255, green: 96/255, blue: 96/255, alpha: 1.0))
        
            // add values for 'amber' bars
        let bar2Entry1 = BarChartDataEntry(x: 0, yValues: [amberBarValues[0]])
        let bar2Entry2 = BarChartDataEntry(x: 0, yValues: [amberBarValues[1]])
        let bar2Entry3 = BarChartDataEntry(x: 0, yValues: [amberBarValues[2]])
        let bar2Entry4 = BarChartDataEntry(x: 0, yValues: [amberBarValues[3]])
        let bar2Entry5 = BarChartDataEntry(x: 0, yValues: [amberBarValues[4]])
        let barDataSet2 = BarChartDataSet(values: [bar2Entry1, bar2Entry2, bar2Entry3, bar2Entry4, bar2Entry5], label: nil)
        barDataSet2.setColor(UIColor(red: 255/255, green: 211/255, blue: 95/255, alpha: 1.0))
        
            // add values for 'green' bars
        let bar3Entry1 = BarChartDataEntry(x: 0, yValues: [greenBarValues[0]])
        let bar3Entry2 = BarChartDataEntry(x: 0, yValues: [greenBarValues[1]])
        let bar3Entry3 = BarChartDataEntry(x: 0, yValues: [greenBarValues[2]])
        let bar3Entry4 = BarChartDataEntry(x: 0, yValues: [greenBarValues[3]])
        let bar3Entry5 = BarChartDataEntry(x: 0, yValues: [greenBarValues[4]])
        let barDataSet3 = BarChartDataSet(values: [bar3Entry1, bar3Entry2, bar3Entry3, bar3Entry4, bar3Entry5], label: nil)
        barDataSet3.setColor(UIColor(red: 124/255, green: 227/255, blue: 128/255, alpha: 1.0))
        
            // consolidate bar chart data sets
        let barData = BarChartData(dataSets: [barDataSet1, barDataSet2, barDataSet3])
        barData.barWidth = barWidth
        barData.groupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)
        
            // add values for 'incidents' line
        let lineEntry1 = ChartDataEntry(x: 0.5, y: incidentLineValues[0])
        let lineEntry2 = ChartDataEntry(x: 1.5, y: incidentLineValues[1])
        let lineEntry3 = ChartDataEntry(x: 2.5, y: incidentLineValues[2])
        let lineEntry4 = ChartDataEntry(x: 3.5, y: incidentLineValues[3])
        let lineEntry5 = ChartDataEntry(x: 4.6, y: incidentLineValues[4])
        
            // consolidate line chart data sets
        let lineDataSet = LineChartDataSet(values: [lineEntry1, lineEntry2, lineEntry3, lineEntry4, lineEntry5], label: nil)
        lineDataSet.setColor(UIColor(red: 196/255, green: 111/255, blue: 251/255, alpha: 1.0))
        lineDataSet.fillColor = UIColor(red: 196/255, green: 111/255, blue: 251/255, alpha: 1.0)
        lineDataSet.fillAlpha = 0.1
        lineDataSet.drawFilledEnabled = true
        lineDataSet.lineWidth = 4.0
        lineDataSet.axisDependency = .left
        lineDataSet.drawCirclesEnabled = false
        let lineData = LineChartData(dataSet: lineDataSet)
        
            // consolidate line chart data
        let data = CombinedChartData()
        data.lineData = lineData
        data.barData = barData
        
            // and add bar/line data sets to chart
        chartView.data = data
        chartView.data?.setDrawValues(false)
        chartView.notifyDataSetChanged()
        
        // ---------
        
            // set RAGs Chart data
        RAGsChartReds.setValue(to: redAverageValue)
        RAGsChartAmbers.setValue(to: amberAverageValue)
        RAGsChartGreens.setValue(to: greenAverageValue)
        
        // ---------
        
            // Set Incidents Chart data
        IncidentsChartIncidents.setValue(to: incidentAverageValue)
    }
    
    
    
    // Triggers animation of chart values when the view is trainsitioned to
    override func viewWillAppear(_ animated: Bool) {
        animateChart()
    }
    
    
    
    // Animates combined bar/line chart values
    func animateChart() {
        chartView.animate(xAxisDuration: Constants.ADMIN_RAGSANDINCIDENTS_REPORT_ANIMATION_SPEED, yAxisDuration: Constants.ADMIN_RAGSANDINCIDENTS_REPORT_ANIMATION_SPEED)
    }


}
