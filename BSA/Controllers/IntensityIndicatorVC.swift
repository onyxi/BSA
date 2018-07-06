//
//  IntensityIndicatorVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 28/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

protocol IntensitySelectionDelegate {
    func setIntensity(to selection: Float)
}

class IntensityIndicatorVC: UIViewController {
    
    @IBOutlet weak var intensityChartCard: UIView!
    @IBOutlet weak var intensityIndicator: IntensityIndicator!
    
    var intensityIndicationDelegate: IntensitySelectionDelegate?
    var intensity: Float = 0.5

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Please Indicate..."
        
        intensityChartCard.backgroundColor = .white
        intensityIndicator.intensity = self.intensity
        
    }

    @IBAction func okButtonPressed(_ sender: Any) {
        intensityIndicationDelegate?.setIntensity(to: intensity)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        intensityIndicator.intensity = sender.value
        intensity = sender.value
    }
    
}
