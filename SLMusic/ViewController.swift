//
//  ViewController.swift
//  SLMusic
//
//  Created by Björn Åhström on 2019-04-29.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorderAndRadius()
        label.text = "Välkommen! Tryck på knappen"
        
    }
    
    func setBorderAndRadius() {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.magenta.cgColor
        button.layer.cornerRadius = 25
    }

    @IBAction func button(_ sender: UIButton) {
        if textField.text == "" {
            label.text = "Du bör skriva något"
        } else {
        label.text = textField.text
            textField.text = ""
        }
    }
    @IBAction func goToSettings(_ sender: Any) {
        performSegue(withIdentifier: "goToSettingsVC", sender: self)
    }
    
}

