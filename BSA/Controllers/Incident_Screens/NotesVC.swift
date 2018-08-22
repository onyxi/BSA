//
//  NotesVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 28/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows a String value (Incident notes) to be sent to the delegate
protocol NotesAdditionDelegate {
    func setNotes(to note: String)
}

class NotesVC: UIViewController, UITextViewDelegate {
    
    // UI handles:
    @IBOutlet weak var notesCard: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    
    // Properties:
    var notesAdditionDelegate: NotesAdditionDelegate!

    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // set color and title
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Add Notes..."
        
            // set textview delegate
        notesTextView.delegate = self
        
            // set up text area appearance
        notesCard.backgroundColor = .white
        notesTextView.text = "Add Notes..."
        notesTextView.textColor = Constants.GRAY_LIGHT
    
            // add swipe-gesture recognisers to main view
        addGestureRecognisers()
    }
    
    // Adds right swipe-gesture recogniser to the main view
    func addGestureRecognisers() {
        
        // add right-swipe recogniser
        var swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(processGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    
    // Processes recognised right swipe recognisers
    @objc func processGesture(gesture: UIGestureRecognizer) {
        if let gesture = gesture as? UISwipeGestureRecognizer {
            switch gesture.direction {
                
            // navigate back to previous screen
            case UISwipeGestureRecognizerDirection.right:
                self.navigationController?.popViewController(animated: true)
                
            default:
                break
            }
        }
    }
    
    // Clears placeholder text when user begins editing the text view
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Constants.GRAY_LIGHT {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // Adds placeholder text if the user leaves the text view blank after editing
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add Notes..."
            textView.textColor = Constants.GRAY_LIGHT
        }
    }
    

    // Sets delegate's 'Notes' value to thic VC's String (notes) value, before segueing back to parent VC.
    @IBAction func okButtonPressed(_ sender: Any) {
        if notesTextView.text != "Add Notes..." {
            notesAdditionDelegate.setNotes(to: notesTextView.text)
        }
        self.navigationController?.popViewController(animated: true)
    }


}
