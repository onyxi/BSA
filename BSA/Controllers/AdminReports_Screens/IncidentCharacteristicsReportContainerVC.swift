//
//  IncidentCharacteristicsReportContainerVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 18/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit
import Charts

class IncidentCharacteristicsReportContainerVC: UIViewController {

    // UI handles:
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var totalChartTitleLabel: UILabel!
    @IBOutlet weak var totalChartValueLabel: UILabel!
    @IBOutlet weak var intensityChartTitleLabel: UILabel!
    @IBOutlet weak var intensityIndicator: IntensityIndicator!
    @IBOutlet weak var behavioursChartTitleLabel: UILabel!
    @IBOutlet weak var purposesChartTitleLabel: UILabel!
    @IBOutlet weak var behavioursHorizontalBarChart: HorizontalBarChartView!
    @IBOutlet weak var purposesHorizontalBarChart: HorizontalBarChartView!
    
    
    // Properties:
        // inital empty values for the charts
    var totalIncidentsValue: Int = 0
    var averageIntensityValue: Float = 0.0
    var kickingValue: Double = 0.0
    var headbuttValue: Double = 0.0
    var hittingValue: Double = 0.0
    var bitingValue: Double = 0.0
    var slappingValue: Double = 0.0
    var scratchingValue: Double = 0.0
    var clothesGrabbingValue: Double = 0.0
    var hairPullingValue: Double = 0.0
    var socialAttentionValue: Double = 0.0
    var tangiblesValue: Double = 0.0
    var escapeValue: Double = 0.0
    var sensoryValue: Double = 0.0
    var healthValue: Double = 0.0
    var activityAvoidanceValue: Double = 0.0
    var unknownValue: Double = 0.0
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // set up charts' appearance and give initial empty data set
        setupCharts()
        updateCharts()
        updateLayoutForOrientation()
    }
    
    // Configures charts' appearance and properties
    func setupCharts() {
        
            // setup 'total incidents' chart
        totalChartTitleLabel.text = "Total Incidents"
        
            // setup 'average intensity' chart
        intensityChartTitleLabel.text = "Average Intensity of Incidents"
        
            // setup 'behaviours percentages' chart
        behavioursChartTitleLabel.text = "Percentage of Behaviour-Types involved in Incidents"
        behavioursHorizontalBarChart.xAxis.enabled = false
        behavioursHorizontalBarChart.leftAxis.drawLabelsEnabled = false
        behavioursHorizontalBarChart.leftAxis.drawAxisLineEnabled = false
        behavioursHorizontalBarChart.leftAxis.zeroLineWidth = 3
        behavioursHorizontalBarChart.leftAxis.drawGridLinesEnabled = false
        behavioursHorizontalBarChart.rightAxis.enabled = false
        behavioursHorizontalBarChart.leftAxis.drawZeroLineEnabled = true
        behavioursHorizontalBarChart.drawValueAboveBarEnabled = true
        behavioursHorizontalBarChart.leftAxis.axisMinimum = 0
        behavioursHorizontalBarChart.chartDescription?.text = ""
        behavioursHorizontalBarChart.legend.enabled = false
        behavioursHorizontalBarChart.isUserInteractionEnabled = false
        
            // setup 'purposes percentages' chart
        purposesChartTitleLabel.text = "Percentage of Purpose-Types involved in Incidents"
        purposesHorizontalBarChart.xAxis.enabled = false
        purposesHorizontalBarChart.leftAxis.drawLabelsEnabled = false
        purposesHorizontalBarChart.leftAxis.drawAxisLineEnabled = false
        purposesHorizontalBarChart.leftAxis.zeroLineWidth = 3
        purposesHorizontalBarChart.leftAxis.drawGridLinesEnabled = false
        purposesHorizontalBarChart.rightAxis.enabled = false
        purposesHorizontalBarChart.leftAxis.drawZeroLineEnabled = true
        purposesHorizontalBarChart.drawValueAboveBarEnabled = true
        purposesHorizontalBarChart.leftAxis.axisMinimum = 0
        purposesHorizontalBarChart.chartDescription?.text = ""
        purposesHorizontalBarChart.legend.enabled = false
        purposesHorizontalBarChart.isUserInteractionEnabled = false
    }
    
    
    // Unpacks data sets for use in the charts - first checking to make sure that a valid data set has been given
    func addChatData(chartData: (totalIncidents: Int, averageIntensity: Float, behaviourPercentages: [Double], purposePercentages: [Double])) {
        
            // check to make sure data set is valid
        guard chartData.behaviourPercentages.count == 8, chartData.purposePercentages.count == 7 else {
                // invalid data given
            print("invalid data for Incident Characteristics report")
            return
        }
        
            // unpack total incidents data
        totalIncidentsValue = chartData.totalIncidents
        
            // unpack average intensity data
        averageIntensityValue = chartData.averageIntensity
        
            // unpack behaviours percentages data
        kickingValue = chartData.behaviourPercentages[0]
        headbuttValue = chartData.behaviourPercentages[1]
        hittingValue = chartData.behaviourPercentages[2]
        bitingValue = chartData.behaviourPercentages[3]
        slappingValue = chartData.behaviourPercentages[4]
        scratchingValue = chartData.behaviourPercentages[5]
        clothesGrabbingValue = chartData.behaviourPercentages[6]
        hairPullingValue = chartData.behaviourPercentages[7]
        
            // unpack purposes percentages data
        socialAttentionValue = chartData.purposePercentages[0]
        tangiblesValue = chartData.purposePercentages[1]
        escapeValue = chartData.purposePercentages[2]
        sensoryValue = chartData.purposePercentages[3]
        healthValue = chartData.purposePercentages[4]
        activityAvoidanceValue = chartData.purposePercentages[5]
        unknownValue = chartData.purposePercentages[6]
        
            // update charts
        updateCharts()
    }
    
    
    // Updates all report charts with currently held data values
    func updateCharts() {
        
        // Set 'total incidents' chart data
        totalChartValueLabel.text = String(totalIncidentsValue)
        
        // ----
        
        // Set 'average intensity' chart data
        intensityIndicator.animateIntensity(to: averageIntensityValue)
        
        // ----
        
        // Set 'behaviours percentages' chart data
        let entryKicking = BarChartDataEntry(x: 8.0, y: kickingValue)
        let entryHeadbutt = BarChartDataEntry(x: 7.0, y: headbuttValue)
        let entryHitting = BarChartDataEntry(x: 6.0, y: hittingValue)
        let entryBiting = BarChartDataEntry(x: 5.0, y: bitingValue)
        let entrySlapping = BarChartDataEntry(x: 4.0, y: slappingValue)
        let entryScratching = BarChartDataEntry(x: 3.0, y: scratchingValue)
        let entryClothesGrabbing = BarChartDataEntry(x: 2.0, y: clothesGrabbingValue)
        let entryHairPulling = BarChartDataEntry(x: 1.0, y: hairPullingValue)
        
        let behavioursDataSet = BarChartDataSet(values: [entryKicking, entryHeadbutt, entryHitting, entryBiting, entrySlapping, entryScratching, entryClothesGrabbing, entryHairPulling], label: nil)
        
        behavioursDataSet.valueFormatter = PercentFormatter()
        behavioursDataSet.setColors([
            UIColor(red: 174/255, green: 183/255, blue: 232/255, alpha: 1.0),
            UIColor(red: 113/255, green: 126/255, blue: 184/255, alpha: 1.0),
            UIColor(red: 82/255, green: 148/255, blue: 235/255, alpha: 1.0),
            UIColor(red: 142/255, green: 147/255, blue: 171/255, alpha: 1.0),
            UIColor(red: 172/255, green: 168/255, blue: 196/255, alpha: 1.0),
            UIColor(red: 108/255, green: 171/255, blue: 231/255, alpha: 1.0),
            UIColor(red: 141/255, green: 163/255, blue: 192/255, alpha: 1.0),
            UIColor(red: 115/255, green: 122/255, blue: 149/255, alpha: 1.0)
            ], alpha: 1.0)
        
        let behavioursData = BarChartData(dataSet: behavioursDataSet)
        behavioursData.setValueFont(Constants.CHART_VALUE_LABEL_FONT)
        behavioursHorizontalBarChart.data = behavioursData
        behavioursHorizontalBarChart.barData?.barWidth = 0.4
        behavioursHorizontalBarChart.notifyDataSetChanged()
        
        // ----
        
        // Set 'purposes percentages' chart data
        let entrySocialAttention = BarChartDataEntry(x: 8.0, y: socialAttentionValue)
        let entryTangibles = BarChartDataEntry(x: 7.0, y: tangiblesValue)
        let entryEscape = BarChartDataEntry(x: 6.0, y: escapeValue)
        let entrySensory = BarChartDataEntry(x: 5.0, y: sensoryValue)
        let entryHealth = BarChartDataEntry(x: 4.0, y: healthValue)
        let entryActivityAvoidance = BarChartDataEntry(x: 3.0, y: activityAvoidanceValue)
        let entryUnknown = BarChartDataEntry(x: 2.0, y: unknownValue)
        
        let purposesDataSet = BarChartDataSet(values: [entrySocialAttention, entryTangibles, entryEscape, entrySensory, entryHealth, entryActivityAvoidance, entryUnknown], label: nil)

        purposesDataSet.valueFormatter = PercentFormatter()
        purposesDataSet.setColors([
            UIColor(red: 229/255, green: 174/255, blue: 232/255, alpha: 1.0),
            UIColor(red: 218/255, green: 51/255, blue: 238/255, alpha: 1.0),
            UIColor(red: 192/255, green: 130/255, blue: 188/255, alpha: 1.0),
            UIColor(red: 147/255, green: 46/255, blue: 160/255, alpha: 1.0),
            UIColor(red: 213/255, green: 152/255, blue: 225/255, alpha: 1.0),
            UIColor(red: 199/255, green: 46/255, blue: 215/255, alpha: 1.0),
            UIColor(red: 255/255, green: 166/255, blue: 243/255, alpha: 1.0)
            ], alpha: 1.0)
        
        
        let purposesData = BarChartData(dataSet: purposesDataSet)
        purposesData.setValueFont(Constants.CHART_VALUE_LABEL_FONT)
        purposesHorizontalBarChart.data = purposesData
        purposesHorizontalBarChart.barData?.barWidth = 0.4
        purposesHorizontalBarChart.notifyDataSetChanged()
    }
    
    
    // Triggers animation of chart values when the view is trainsitioned to
    override func viewWillAppear(_ animated: Bool) {
        animateChart()
    }
    
    // Animates combined bar/line chart values
    func animateChart() {
       
        intensityIndicator.animateIntensity(to: intensityIndicator.intensity)
        behavioursHorizontalBarChart.animate(xAxisDuration: Constants.REPORT_ANIMATION_SPEED, easingOption: .linear)
        purposesHorizontalBarChart.animate(xAxisDuration: Constants.REPORT_ANIMATION_SPEED, easingOption: .linear)
    }
    
    // Changes the layout to suit the screen's orientation
    func updateLayoutForOrientation() {
        if UIDevice.current.orientation.isLandscape {
            stackView.axis = .horizontal
        } else {
            stackView.axis = .vertical
        }
    }
    
    // Updates the screen's layout when the orientation is changed
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateLayoutForOrientation()
    }


}
