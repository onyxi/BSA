//
//  IntensityIndicatorVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 28/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows an Floating Point value (incident intensity) to be sent to the delegate
protocol IntensitySelectionDelegate {
    func setIntensity(to selection: Float)
}

class IntensityIndicatorVC: UIViewController {
    
    // UI handles:
    @IBOutlet weak var intensityChartCard: UIView!
    @IBOutlet weak var intensityIndicator: IntensityIndicator!
    
    // Properties:
    var intensityIndicationDelegate: IntensitySelectionDelegate?
    var intensity: Float = 0.5

    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()

            // set VC color and title
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Please Indicate..."
    
            // set up chart's initial appearance
        intensityChartCard.backgroundColor = .white
        intensityIndicator.intensity = self.intensity
    }

    // Updates intensity value to reflect a change in the slider's value
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        intensityIndicator.intensity = sender.value
        intensity = sender.value
    }
    
    // Sets delegate's 'Intensity' value to thic VC's Floating Point intensity value, before segueing back to parent VC.
    @IBAction func okButtonPressed(_ sender: Any) {
        intensityIndicationDelegate?.setIntensity(to: intensity)
        self.navigationController?.popViewController(animated: true)
    }
    
}
