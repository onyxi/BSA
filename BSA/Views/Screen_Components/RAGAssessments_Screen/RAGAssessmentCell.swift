//
//  RAGAssessmentCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 19/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

protocol RAGSelectionDelegate {
    func didSelectRAG(selection: RAGStatus, forCellWith: Int)
}

class RAGAssessmentCell: UITableViewCell {
    
    // UI handles:
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var studentNameLabel: UILabel!

    @IBOutlet weak var naButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var amberButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!

    @IBOutlet weak var selectionIndicator: SelectionIndicator!
    @IBOutlet weak var selectionIndicatorTrailingConstraint: NSLayoutConstraint!
    
    var rAGSelectionDelegate: RAGSelectionDelegate!
    
    var selectionIndicatorPosition: RAGStatus = .green
    
    func refreshSelectionIndicator() {
        switch selectionIndicatorPosition {
        case .green:
            self.selectionIndicator.layer.backgroundColor = Constants.GREEN.cgColor
            self.selectionIndicatorTrailingConstraint.constant = 15
            self.greenButton.setTitleColor(.white, for: .normal)
            self.amberButton.setTitleColor(Constants.GRAY, for: .normal)
            self.redButton.setTitleColor(Constants.GRAY, for: .normal)
            self.naButton.setTitleColor(Constants.GRAY, for: .normal)
        case .amber:
            self.selectionIndicator.layer.backgroundColor = Constants.AMBER.cgColor
            self.selectionIndicatorTrailingConstraint.constant = 130
            self.greenButton.setTitleColor(Constants.GRAY, for: .normal)
            self.amberButton.setTitleColor(.white, for: .normal)
            self.redButton.setTitleColor(Constants.GRAY, for: .normal)
            self.naButton.setTitleColor(Constants.GRAY, for: .normal)
        case .red:
            self.selectionIndicator.layer.backgroundColor = Constants.RED.cgColor
            self.selectionIndicatorTrailingConstraint.constant = 245
            self.greenButton.setTitleColor(Constants.GRAY, for: .normal)
            self.amberButton.setTitleColor(Constants.GRAY, for: .normal)
            self.redButton.setTitleColor(.white, for: .normal)
            self.naButton.setTitleColor(Constants.GRAY, for: .normal)
        case .na:
            self.selectionIndicator.layer.backgroundColor = Constants.GRAY_DARK.cgColor
            self.selectionIndicatorTrailingConstraint.constant = 360
            self.greenButton.setTitleColor(Constants.GRAY, for: .normal)
            self.amberButton.setTitleColor(Constants.GRAY, for: .normal)
            self.redButton.setTitleColor(Constants.GRAY, for: .normal)
            self.naButton.setTitleColor(.white, for: .normal)
        case .none:
            self.selectionIndicator.layer.backgroundColor = UIColor.clear.cgColor
            self.greenButton.setTitleColor(Constants.GRAY, for: .normal)
            self.amberButton.setTitleColor(Constants.GRAY, for: .normal)
            self.redButton.setTitleColor(Constants.GRAY, for: .normal)
            self.naButton.setTitleColor(Constants.GRAY, for: .normal)
        }
    }
    
    @IBAction func greenButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: Constants.RAG_SELECTION_SPEED, animations: {
            self.selectionIndicator.layer.backgroundColor = Constants.GREEN.cgColor
            self.selectionIndicatorTrailingConstraint.constant = 15
            self.layoutIfNeeded()
        })
        sender.setTitleColor(.white, for: .normal)
        self.naButton.setTitleColor(Constants.GRAY, for: .normal)
        self.redButton.setTitleColor(Constants.GRAY, for: .normal)
        self.amberButton.setTitleColor(Constants.GRAY, for: .normal)
        selectionIndicatorPosition = .green
        rAGSelectionDelegate.didSelectRAG(selection: .green, forCellWith: self.tag)
    }

    
    @IBAction func amberButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: Constants.RAG_SELECTION_SPEED, animations: {
            self.selectionIndicator.layer.backgroundColor = Constants.AMBER.cgColor
            self.selectionIndicatorTrailingConstraint.constant = 130
            self.layoutIfNeeded()
        })
        sender.setTitleColor(.white, for: .normal)
        self.naButton.setTitleColor(Constants.GRAY, for: .normal)
        self.redButton.setTitleColor(Constants.GRAY, for: .normal)
        self.greenButton.setTitleColor(Constants.GRAY, for: .normal)
        selectionIndicatorPosition = .amber
        rAGSelectionDelegate.didSelectRAG(selection: .amber, forCellWith: self.tag)
    }

    
    
    @IBAction func redButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: Constants.RAG_SELECTION_SPEED, animations: {
            self.selectionIndicator.layer.backgroundColor = Constants.RED.cgColor
            self.selectionIndicatorTrailingConstraint.constant = 245
            self.layoutIfNeeded()
        })
        sender.setTitleColor(.white, for: .normal)
        self.naButton.setTitleColor(Constants.GRAY, for: .normal)
        self.amberButton.setTitleColor(Constants.GRAY, for: .normal)
        self.greenButton.setTitleColor(Constants.GRAY, for: .normal)
        selectionIndicatorPosition = .red
        rAGSelectionDelegate.didSelectRAG(selection: .red, forCellWith: self.tag)
    }
    
    
    @IBAction func naButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: Constants.RAG_SELECTION_SPEED, animations: {
            self.selectionIndicator.layer.backgroundColor = Constants.GRAY_DARK.cgColor
            self.selectionIndicatorTrailingConstraint.constant = 360
            self.layoutIfNeeded()
        })
        sender.setTitleColor(.white, for: .normal)
        self.redButton.setTitleColor(Constants.GRAY, for: .normal)
        self.amberButton.setTitleColor(Constants.GRAY, for: .normal)
        self.greenButton.setTitleColor(Constants.GRAY, for: .normal)
        selectionIndicatorPosition = .na
        rAGSelectionDelegate.didSelectRAG(selection: .na, forCellWith: self.tag)
    }
    
    
    
    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // set color and shadow
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
        cellContentView.layer.shadowColor = UIColor.black.cgColor
        cellContentView.layer.shadowOffset = CGSize(width: 1, height: 2)
        cellContentView.layer.shadowRadius = 4
        cellContentView.layer.masksToBounds = false
        cellContentView.layer.shadowOpacity = 0.5
        
            // configure N/A, Red, Amber and Green buttons on the cell
        setupButtons()
    }


    // Configures pressable N/A, Red, Amber and Green buttons on the cell
    func setupButtons() {
        
        greenButton.backgroundColor = .clear
        greenButton.setTitle("Green", for: .normal)
        greenButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        greenButton.setTitleColor(.white, for: .normal)

        amberButton.backgroundColor = .clear
        amberButton.setTitle("Amber", for: .normal)
        amberButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        amberButton.setTitleColor(Constants.GRAY, for: .normal)

        redButton.backgroundColor = .clear
        redButton.setTitle("Red", for: .normal)
        redButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        redButton.setTitleColor(Constants.GRAY, for: .normal)

        naButton.backgroundColor = .clear
        naButton.setTitle("N/A", for: .normal)
        naButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        naButton.setTitleColor(Constants.GRAY_LIGHT, for: .normal)

        selectionIndicator.backgroundColor = Constants.GREEN
        selectionIndicator.layer.cornerRadius = 4
        selectionIndicator.layer.masksToBounds = true

    }
    
    
}


