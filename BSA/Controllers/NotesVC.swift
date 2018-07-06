//
//  NotesVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 28/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

protocol NotesAdditionDelegate {
    func setNotes(to note: String)
}

class NotesVC: UIViewController {
    
    @IBOutlet weak var notesCard: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    
    var notesAdditionDelegate: NotesAdditionDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Please Add..."
        
        notesCard.backgroundColor = .white
    }

    @IBAction func okButtonPressed(_ sender: Any) {
        notesAdditionDelegate.setNotes(to: notesTextView.text)
        self.navigationController?.popViewController(animated: true)
    }


}
