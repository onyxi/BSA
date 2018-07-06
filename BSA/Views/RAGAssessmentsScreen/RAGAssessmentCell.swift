//
//  RAGAssessmentCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 19/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class RAGAssessmentCell: UITableViewCell {
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var studentNameLabel: UILabel!
    
    var selectionIndicator: UIView!
    var naButton: UIButton!
    var redButton: UIButton!
    var amberButton: UIButton!
    var greenButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
        cellContentView.layer.shadowColor = UIColor.black.cgColor
        cellContentView.layer.shadowOffset = CGSize(width: 1, height: 2)
        cellContentView.layer.shadowRadius = 4
        cellContentView.layer.masksToBounds = false
        cellContentView.layer.shadowOpacity = 0.5
        
        setupButtons()
    }

    var naPosition: CGRect!
    var redPosition: CGRect!
    var amberPosition: CGRect!
    var greenPosition: CGRect!
    var selectionIndicatorPosition: SelectionIndicatorPosition!
    
    
    func setupButtons() {
        
        greenPosition = CGRect(x: cellContentView.frame.width - 110, y: (cellContentView.frame.height/2) - 25, width: 100, height: 50)
        greenButton = UIButton(frame: CGRect(x: cellContentView.frame.width - 110, y: 0, width: 100, height: cellContentView.frame.height))
        greenButton.backgroundColor = .clear
        greenButton.setTitle("Green", for: .normal)
        greenButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        greenButton.setTitleColor(.white, for: .normal)
        greenButton.addTarget(self, action: #selector(greenButtonPressed(sender:)), for: .touchUpInside)
        
        amberPosition = CGRect(x: cellContentView.frame.width - 215, y: (cellContentView.frame.height/2) - 25, width: 100, height: 50)
        amberButton = UIButton(frame: CGRect(x: cellContentView.frame.width - 215, y: 0, width: 100, height: cellContentView.frame.height))
        amberButton.backgroundColor = .clear
        amberButton.setTitle("Amber", for: .normal)
        amberButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        amberButton.setTitleColor(Constants.GRAY, for: .normal)
        amberButton.addTarget(self, action: #selector(amberButtonPressed(sender:)), for: .touchUpInside)
        
        redPosition = CGRect(x: cellContentView.frame.width - 320, y: (cellContentView.frame.height/2) - 25, width: 100, height: 50)
        redButton = UIButton(frame: CGRect(x: cellContentView.frame.width - 320, y: 0, width: 100, height: cellContentView.frame.height))
        redButton.backgroundColor = .clear
        redButton.setTitle("Red", for: .normal)
        redButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        redButton.setTitleColor(Constants.GRAY, for: .normal)
        redButton.addTarget(self, action: #selector(redButtonPressed(sender:)), for: .touchUpInside)
        
        naPosition = CGRect(x: cellContentView.frame.width - 425, y: (cellContentView.frame.height/2) - 25, width: 100, height: 50)
        naButton = UIButton(frame: CGRect(x: cellContentView.frame.width - 425, y: 0, width: 100, height: cellContentView.frame.height))
        naButton.backgroundColor = .clear
        naButton.setTitle("N/A", for: .normal)
        naButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        naButton.setTitleColor(Constants.LIGHT_GRAY, for: .normal)
        naButton.addTarget(self, action: #selector(naButtonPressed(sender:)), for: .touchUpInside)
        
        selectionIndicator = UIView(frame: greenPosition)
        selectionIndicatorPosition = .green
        selectionIndicator.backgroundColor = Constants.GREEN
        selectionIndicator.layer.cornerRadius = 4
        selectionIndicator.layer.masksToBounds = true
        
        cellContentView.addSubview(selectionIndicator)
        cellContentView.addSubview(naButton)
        cellContentView.addSubview(redButton)
        cellContentView.addSubview(amberButton)
        cellContentView.addSubview(greenButton)
    }
    
    func updateButtonLayout() {
        greenPosition = CGRect(x: cellContentView.frame.width - 110, y: (cellContentView.frame.height/2) - 25, width: 100, height: 50)
        greenButton.frame = greenPosition
        
        amberPosition = CGRect(x: cellContentView.frame.width - 215, y: (cellContentView.frame.height/2) - 25, width: 100, height: 50)
        amberButton.frame = amberPosition
        
        redPosition = CGRect(x: cellContentView.frame.width - 320, y: (cellContentView.frame.height/2) - 25, width: 100, height: 50)
        redButton.frame = redPosition
        
        naPosition = CGRect(x: cellContentView.frame.width - 425, y: (cellContentView.frame.height/2) - 25, width: 100, height: 50)
        naButton.frame = naPosition
        
        switch self.selectionIndicatorPosition {
        case .green:
            selectionIndicator.frame = greenPosition
        case .amber:
            selectionIndicator.frame = amberPosition
        case .red:
            selectionIndicator.frame = redPosition
        case .na:
            selectionIndicator.frame = naPosition
        default:
            break
        }
        
    }
    
    
    @objc fileprivate func naButtonPressed(sender: UIButton) {
        UIView.animate(withDuration: Constants.RAG_SELECTION_SPEED) {
            self.selectionIndicator.layer.backgroundColor = Constants.DARK_GRAY.cgColor
            self.selectionIndicator.frame = self.naPosition
            self.selectionIndicatorPosition = .na
            sender.setTitleColor(.white, for: .normal)
            self.redButton.setTitleColor(Constants.GRAY, for: .normal)
            self.amberButton.setTitleColor(Constants.GRAY, for: .normal)
            self.greenButton.setTitleColor(Constants.GRAY, for: .normal)
        }
    }
    
    @objc fileprivate func redButtonPressed(sender: UIButton) {
        UIView.animate(withDuration: Constants.RAG_SELECTION_SPEED) {
            self.selectionIndicator.layer.backgroundColor = Constants.RED.cgColor
            self.selectionIndicator.frame = self.redPosition
            self.selectionIndicatorPosition = .red
            sender.setTitleColor(.white, for: .normal)
            self.naButton.setTitleColor(Constants.GRAY, for: .normal)
            self.amberButton.setTitleColor(Constants.GRAY, for: .normal)
            self.greenButton.setTitleColor(Constants.GRAY, for: .normal)
        }
    }
    
    @objc fileprivate func amberButtonPressed(sender: UIButton) {
        UIView.animate(withDuration: Constants.RAG_SELECTION_SPEED) {
            self.selectionIndicator.layer.backgroundColor = Constants.AMBER.cgColor
            self.selectionIndicator.frame = self.amberPosition
            self.selectionIndicatorPosition = .amber
            sender.setTitleColor(.white, for: .normal)
            self.naButton.setTitleColor(Constants.GRAY, for: .normal)
            self.redButton.setTitleColor(Constants.GRAY, for: .normal)
            self.greenButton.setTitleColor(Constants.GRAY, for: .normal)
        }
    }
    
    @objc fileprivate func greenButtonPressed(sender: UIButton) {
        UIView.animate(withDuration: Constants.RAG_SELECTION_SPEED) {
            self.selectionIndicator.layer.backgroundColor = Constants.GREEN.cgColor
            self.selectionIndicator.frame = self.greenPosition
            self.selectionIndicatorPosition = .green
            sender.setTitleColor(.white, for: .normal)
            self.naButton.setTitleColor(Constants.GRAY, for: .normal)
            self.redButton.setTitleColor(Constants.GRAY, for: .normal)
            self.amberButton.setTitleColor(Constants.GRAY, for: .normal)
        }
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

enum SelectionIndicatorPosition {
    case green
    case amber
    case red
    case na
}
